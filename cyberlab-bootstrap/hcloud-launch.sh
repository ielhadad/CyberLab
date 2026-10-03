#!/usr/bin/env bash
# Launch the CyberLab on Hetzner Cloud with the hcloud CLI.
# Updated 2026-10-03 for the segmented range: forwards the attacker RDP desktop (3389)
# in the convenience tunnel and recommends a 16 GB type for the XRDP attacker image.
#
# Prereqs: hcloud CLI installed and a project token set up (hcloud context create cyberlab),
#          an SSH key pair on this computer (ssh-keygen -t ed25519).
# Usage: bash hcloud-launch.sh [location: nbg1|fsn1|hel1] [path/to/bootstrap-vps.sh]
#
# Type cx43 = 8 shared vCPU (x86), 16 GB RAM, 160 GB NVMe - recommended, because the
# attacker is now a Kali + XFCE/XRDP desktop image (~3 GB). cx33 (4 vCPU, 8 GB) is the
# workable minimum; the cloud bootstrap adds swap so 8 GB does not OOM. NEVER pick a CAX
# type: those are Arm servers and the lab's target images (DVWA, Metasploitable) are x86-only.
set -euo pipefail

LOCATION="${1:-nbg1}"
BOOTSTRAP="${2:-bootstrap-vps.sh}"       # the VPS bootstrap (swap + ufw + fail2ban); works on any cloud Ubuntu
NAME=cyberlab
TYPE="${HCLOUD_TYPE:-cx43}"
PUBKEY="${SSH_PUBKEY:-$HOME/.ssh/id_ed25519.pub}"
[ -f "$BOOTSTRAP" ] || { echo "Missing $BOOTSTRAP (pass the path to your cloud bootstrap script)"; exit 1; }
[ -f "$PUBKEY" ] || { echo "Missing $PUBKEY (run ssh-keygen -t ed25519)"; exit 1; }

# 1. SSH key
hcloud ssh-key describe $NAME-key >/dev/null 2>&1 || \
  hcloud ssh-key create --name $NAME-key --public-key-from-file "$PUBKEY"

# 2. Cloud firewall: SSH from your IP only (a second layer on top of UFW).
#    RDP (3389), Portainer (9443), SOCKS (1080) and CAI (7682) are NOT opened here -
#    they are bound to 127.0.0.1 on the server and reached over the SSH tunnel below.
MYIP=$(curl -s https://checkip.amazonaws.com)/32
if ! hcloud firewall describe $NAME-fw >/dev/null 2>&1; then
  hcloud firewall create --name $NAME-fw
fi
hcloud firewall add-rule $NAME-fw --direction in --protocol tcp --port 22 \
  --source-ips "$MYIP" --description "SSH from $MYIP" >/dev/null 2>&1 || true
echo "[hetzner] firewall $NAME-fw allows SSH from $MYIP"

# 3. User-data = create a sudo user 'labadmin' with root's key, then the normal bootstrap
USERDATA=$(mktemp)
cat > "$USERDATA" <<'PRELUDE'
#!/usr/bin/env bash
# Hetzner images log in as root; create labadmin and disable root SSH login
if ! id labadmin >/dev/null 2>&1; then
  adduser --disabled-password --gecos "" labadmin
  usermod -aG sudo labadmin
  echo "labadmin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-labadmin && chmod 440 /etc/sudoers.d/90-labadmin
  install -d -m 700 -o labadmin -g labadmin /home/labadmin/.ssh
  install -m 600 -o labadmin -g labadmin /root/.ssh/authorized_keys /home/labadmin/.ssh/authorized_keys
  echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/02-cyberlab-noroot.conf
fi
PRELUDE
tail -n +2 "$BOOTSTRAP" >> "$USERDATA"

# 4. Server
hcloud server create --name $NAME --type "$TYPE" --image ubuntu-24.04 --location "$LOCATION" \
  --ssh-key $NAME-key --firewall $NAME-fw --user-data-from-file "$USERDATA" \
  --label project=cyberlab
rm -f "$USERDATA"
IP=$(hcloud server ip $NAME)

cat <<EOT

$NAME ($TYPE, $LOCATION) is running at $IP.
The bootstrap takes 10-15 minutes (it also builds the XRDP attacker image). Then:

  # Tunnel: RDP desktop (3389), Portainer (9443), SOCKS browser proxy (1080).
  # Add  -L 7682:127.0.0.1:7682  as well if you enabled CAI (cyberlab cai).
  ssh -L 3389:127.0.0.1:3389 -L 9443:127.0.0.1:9443 -L 1080:127.0.0.1:1080 labadmin@$IP

  tail -f /var/log/cyberlab-bootstrap.log     # watch progress
  cyberlab verify                             # run the self-test

GUI labs: with the tunnel up, point a Remote Desktop client at 127.0.0.1:3389
          (user root / password cyberrange).  CLI: docker exec -it attacker bash
EOT
