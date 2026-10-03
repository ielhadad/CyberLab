#!/usr/bin/env bash
# CyberLab local bootstrap - segmented Internet/DMZ/LAN range (XRDP attacker + BIND DNS).
# Updated 2026-10-03: attacker now builds a Kali + XFCE/XRDP desktop image, a BIND DNS
# server (cipher.lab) is added, and the firewall forwards DNS (53) into the DMZ.
# Usage: sudo bash bootstrap-local.sh [lab-user]   (VirtualBox Kali/Ubuntu, Proxmox pod template)
# Safe to run more than once. Progress: /var/log/cyberlab-bootstrap.log
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }
exec > >(tee -a /var/log/cyberlab-bootstrap.log) 2>&1
echo "[cyberlab] bootstrap started $(date -u +%FT%TZ)"
export DEBIAN_FRONTEND=noninteractive HOME="${HOME:-/root}"

# Lab user: argument, then the sudo caller, then the usual default users
LAB_USER="${1:-${SUDO_USER:-}}"
if [ -z "$LAB_USER" ] || [ "$LAB_USER" = root ]; then
  LAB_USER=""
  for u in ubuntu labadmin kali admin debian; do id "$u" >/dev/null 2>&1 && { LAB_USER="$u"; break; }; done
fi
echo "[cyberlab] lab user: ${LAB_USER:-none}"
TMP=$(mktemp -d)

# --- files ---------------------------------------------------------------
install -d -m 0755 "$(dirname $TMP/install-docker.sh)"
cat > $TMP/install-docker.sh <<'__CYBERLAB_EOF__'
#!/usr/bin/env bash
# Install Docker Engine + Compose plugin on Kali, Debian or Ubuntu.
# Usage: sudo bash install-docker.sh [username-to-add-to-docker-group]
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }
LAB_USER="${1:-${SUDO_USER:-}}"

if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then
  echo "[docker] already installed: $(docker --version)"
else
  . /etc/os-release
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  apt-get install -y -qq ca-certificates curl gnupg >/dev/null
  install -m 0755 -d /etc/apt/keyrings

  case "$ID" in
    kali)   DIST=debian; CODENAME=bookworm ;;   # Kali tracks Debian testing; use Docker's Debian stable repo
    debian) DIST=debian; CODENAME="$VERSION_CODENAME" ;;
    ubuntu) DIST=ubuntu; CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}" ;;
    *) echo "Unsupported OS: $ID (use Kali, Debian or Ubuntu)"; exit 1 ;;
  esac

  curl -fsSL "https://download.docker.com/linux/$DIST/gpg" -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$DIST $CODENAME stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null
fi

systemctl enable --now docker >/dev/null 2>&1 || true

if [ -n "$LAB_USER" ] && id "$LAB_USER" >/dev/null 2>&1; then
  usermod -aG docker "$LAB_USER"
  echo "[docker] added $LAB_USER to the docker group (log out and back in to use docker without sudo)"
fi
docker --version && docker compose version
__CYBERLAB_EOF__
chmod 0755 $TMP/install-docker.sh

# --- attacker image (Kali CLI tools + light XFCE desktop over XRDP) ---------
install -d -m 0755 /opt/cyberlab/attacker
cat > /opt/cyberlab/attacker/Dockerfile <<'__CYBERLAB_EOF__'
# CyberLab attacker image - Kali CLI tools + a light XFCE desktop over XRDP,
# so the GUI labs (Burp, Wireshark, Zenmap, Ettercap, browser) work via RDP.
# Startup (xrdp + lab route) is in docker-compose.yml's command:.
FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive

# CLI toolset + light desktop + xrdp. Add GUI tools your labs need here,
# e.g.: wireshark zaproxy ettercap-graphical nikto metasploit-framework
RUN apt-get update && apt-get install -y --no-install-recommends \
      nmap curl iproute2 iputils-ping netcat-openbsd dnsutils \
      sqlmap hydra nuclei john hashcat ca-certificates git \
      xfce4 xfce4-terminal dbus-x11 xrdp xorgxrdp firefox-esr \
  && rm -rf /var/lib/apt/lists/*

RUN echo "xfce4-session" > /root/.xsession \
 && adduser xrdp ssl-cert \
 && echo 'root:cyberrange' | chpasswd \
 && printf '[Allow Colord all Users]\nIdentity=unix-user:*\nAction=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile\nResultAny=no\nResultInactive=no\nResultActive=yes\n' \
    > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla

EXPOSE 3389
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/attacker/Dockerfile

# --- BIND DNS server (authoritative for cipher.lab, Lab 1) -----------------
install -d -m 0755 /opt/cyberlab/dns/zones
cat > /opt/cyberlab/dns/named.conf <<'__CYBERLAB_EOF__'
options { directory "/var/cache/bind"; recursion yes; allow-query { any; }; };
zone "cipher.lab" {
    type master;
    file "/etc/bind/zones/db.cipher.lab";
    // AXFR is restricted to DMZ addresses - but the router source-NATs the attacker
    // to a DMZ address, so the transfer still succeeds. That bypass is Lab 1's lesson.
    allow-transfer { 10.20.0.0/24; };
};
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/dns/named.conf
cat > /opt/cyberlab/dns/zones/db.cipher.lab <<'__CYBERLAB_EOF__'
$TTL 604800
@   IN  SOA dns.cipher.lab. admin.cipher.lab. ( 4 604800 86400 2419200 604800 )
@          IN  NS   dns.cipher.lab.
@          IN  MX 10 mail.cipher.lab.
@          IN  TXT  "v=spf1 mx -all"
dns        IN  A    10.20.0.53
router     IN  A    10.20.0.254
attacker   IN  A    10.10.0.10
juiceshop  IN  A    10.20.0.11
dvwa       IN  A    10.20.0.12
dvwa-lan   IN  A    10.30.0.12
metasploitable IN A 10.30.0.20
mail       IN  A    10.20.0.25
intranet   IN  CNAME juiceshop.cipher.lab.
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/dns/zones/db.cipher.lab

# --- the range ------------------------------------------------------------
install -d -m 0755 "$(dirname /opt/cyberlab/docker-compose.yml)"
cat > /opt/cyberlab/docker-compose.yml <<'__CYBERLAB_EOF__'
# CyberLab: segmented Internet / DMZ / LAN range on a single Docker host, with a BIND
# DNS server, Suricata IDS, Portainer GUI, an XRDP desktop on the attacker, and an
# optional browser SOCKS proxy.  Host: Kali or Ubuntu (host networking needed for Suricata).
#
# Topology
#   internet 10.10.0.0/24 (br-inet)  attacker(.10) --- router(.254)
#   dmz      10.20.0.0/24 (br-dmz)   router(.254) --- juiceshop(.11), dvwa(.12), dns(.53)
#   lan      10.30.0.0/24 (br-lan)   dvwa(.12, dual-homed pivot) --- metasploitable(.20)
# The attacker reaches the DMZ through the router (web + DNS + icmp only); the LAN is
# reachable only by pivoting through the dual-homed dvwa.
# Host-only published ports: 127.0.0.1 -> 9443 (Portainer), 1080 (SOCKS), 3389 (attacker RDP).

networks:
  internet:
    driver_opts:
      com.docker.network.bridge.name: br-inet
    ipam:
      config:
        - subnet: 10.10.0.0/24
  dmz:
    internal: true
    driver_opts:
      com.docker.network.bridge.name: br-dmz
    ipam:
      config:
        - subnet: 10.20.0.0/24
  lan:
    internal: true
    driver_opts:
      com.docker.network.bridge.name: br-lan
    ipam:
      config:
        - subnet: 10.30.0.0/24
  mgmt: {}   # Portainer only; no lab host is attached

volumes:
  suricata-logs:
  suricata-rules:
  portainer-data:

services:
  router:
    image: alpine:3.20
    container_name: router
    restart: unless-stopped
    cap_add: [NET_ADMIN]
    sysctls:
      - net.ipv4.ip_forward=1
    mem_limit: 64m
    networks:
      internet: { ipv4_address: 10.10.0.254 }
      dmz:      { ipv4_address: 10.20.0.254 }
    command:
      - sh
      - -c
      - |
        command -v iptables >/dev/null || apk add --no-cache iptables >/dev/null
        iptables -F FORWARD; iptables -t nat -F POSTROUTING
        iptables -P FORWARD DROP
        iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        # Firewall policy: Internet -> DMZ web services + DNS + icmp only
        iptables -A FORWARD -s 10.10.0.0/24 -d 10.20.0.0/24 -p tcp -m multiport --dports 80,3000 -j ACCEPT
        iptables -A FORWARD -s 10.10.0.0/24 -d 10.20.0.53 -p udp --dport 53 -j ACCEPT
        iptables -A FORWARD -s 10.10.0.0/24 -d 10.20.0.53 -p tcp --dport 53 -j ACCEPT
        iptables -A FORWARD -s 10.10.0.0/24 -d 10.20.0.0/24 -p icmp -j ACCEPT
        iptables -t nat -A POSTROUTING -d 10.20.0.0/24 -j MASQUERADE
        echo "router ready"; exec tail -f /dev/null

  attacker:
    build: ./attacker              # Kali tools + light XFCE desktop + XRDP
    container_name: attacker
    hostname: attacker
    restart: unless-stopped
    cap_add: [NET_ADMIN, NET_RAW]
    mem_limit: 3g
    shm_size: "1g"
    tty: true
    networks:
      internet: { ipv4_address: 10.10.0.10 }
    ports:
      - "127.0.0.1:1080:1080"      # SOCKS (served by the socks container)
      - "127.0.0.1:3389:3389"      # XRDP desktop, host-only (use "3389:3389" for remote students)
    command:
      - bash
      - -c
      - |
        rm -f /var/run/xrdp/*.pid 2>/dev/null
        service dbus start
        /usr/sbin/xrdp-sesman
        /usr/sbin/xrdp
        ip route replace 10.20.0.0/24 via 10.10.0.254
        if command -v nuclei >/dev/null && [ ! -d "$HOME/nuclei-templates" ]; then
          nuclei -update-templates >/dev/null 2>&1 || true
        fi
        echo "attacker ready (RDP 127.0.0.1:3389, root/cyberrange)"; exec tail -f /dev/null

  socks:
    image: serjs/go-socks5-proxy:latest
    container_name: socks
    restart: unless-stopped
    network_mode: "service:attacker"
    depends_on: [attacker]
    mem_limit: 64m
    environment:
      - REQUIRE_AUTH=false

  dns:
    image: internetsystemsconsortium/bind9:9.18
    container_name: dns
    restart: unless-stopped
    mem_limit: 128m
    networks:
      dmz: { ipv4_address: 10.20.0.53 }
    volumes:
      - /opt/cyberlab/dns/named.conf:/etc/bind/named.conf:ro
      - /opt/cyberlab/dns/zones:/etc/bind/zones:ro

  juiceshop:
    image: bkimminich/juice-shop:latest
    container_name: juiceshop
    restart: unless-stopped
    mem_limit: 512m
    networks:
      dmz: { ipv4_address: 10.20.0.11 }

  dvwa:
    image: vulnerables/web-dvwa:latest
    container_name: dvwa
    restart: unless-stopped
    mem_limit: 256m
    networks:
      dmz: { ipv4_address: 10.20.0.12 }
      lan: { ipv4_address: 10.30.0.12 }

  metasploitable:
    image: tleemcjr/metasploitable2:latest
    container_name: metasploitable
    hostname: metasploitable
    restart: unless-stopped
    mem_limit: 512m
    tty: true
    command: sh -c "/bin/services.sh && tail -f /dev/null"
    networks:
      lan: { ipv4_address: 10.30.0.20 }

  suricata:
    image: jasonish/suricata:latest
    container_name: suricata
    network_mode: host          # needed to sniff the lab bridges
    cap_add: [NET_ADMIN, NET_RAW, SYS_NICE]
    mem_limit: 1g
    restart: unless-stopped
    depends_on: [router, dvwa, metasploitable]
    volumes:
      - suricata-logs:/var/log/suricata
      - suricata-rules:/var/lib/suricata
    # HOME_NET = protected segments, so the attacker (10.10.0.0/24) is EXTERNAL_NET
    command: >
      -i br-inet -i br-lan
      --set vars.address-groups.HOME_NET=[10.20.0.0/24,10.30.0.0/24]

  portainer:
    image: portainer/portainer-ce:lts
    container_name: portainer
    mem_limit: 256m
    restart: unless-stopped
    networks: [mgmt]
    ports:
      - "127.0.0.1:9443:9443"   # host only; never expose to the lab or the internet
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer-data:/data
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/docker-compose.yml

# --- optional CAI (Cybersecurity AI) agent -------------------------------
# Off by default. Enable with:  cyberlab cai   (creates cai/cai.env; add an API key, rerun)
install -d -m 0755 /opt/cyberlab/cai
cat > /opt/cyberlab/cai/Dockerfile <<'__CYBERLAB_EOF__'
# CAI (Cybersecurity AI) container for CyberLab.
# CAI ships as a pip package (cai-framework), not an official image, so we build a small
# Kali-based image around it with a few tools CAI can drive, plus ttyd for browser access.
# It calls an external LLM API - supply a key via cai.env.
FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive
ENV PROMPT_TOOLKIT_NO_CPR=1
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
      nmap netcat-traditional curl wget iputils-ping dnsutils iproute2 git \
      ttyd \
  && rm -rf /var/lib/apt/lists/*
RUN pip install --break-system-packages cai-framework
EXPOSE 7682
# ttyd serves an interactive CAI session in the browser; falls back to a shell.
CMD ["/bin/sh","-c","ttyd -p 7682 -W cai || ttyd -p 7682 -W bash"]
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/cai/Dockerfile
cat > /opt/cyberlab/cai/cai.env.example <<'__CYBERLAB_EOF__'
# Copy to cai.env and set at least one provider key. NEVER commit cai.env.
# OpenAI:
OPENAI_API_KEY="sk-...your key..."
CAI_MODEL="gpt-4o"
# Anthropic (alternative): set ANTHROPIC_API_KEY and a matching CAI_MODEL instead.
# ANTHROPIC_API_KEY="sk-ant-...your key..."
# CAI_MODEL="claude-sonnet-4-5"
PROMPT_TOOLKIT_NO_CPR=1
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/cai/cai.env.example
cat > /opt/cyberlab/docker-compose.cai.yml <<'__CYBERLAB_EOF__'
# Optional CAI agent overlay. The cyberlab CLI includes it automatically once cai/cai.env
# exists, so CAI joins the normal up/verify/status/reset lifecycle. The 'internet' network
# is defined in the base docker-compose.yml and merged in when both files are passed.
services:
  cai:
    build: ./cai
    container_name: cai
    env_file: ./cai/cai.env
    cap_add: [NET_ADMIN, NET_RAW]
    mem_limit: 1g
    restart: unless-stopped
    networks:
      internet: { ipv4_address: 10.10.0.60 }
    ports:
      - "127.0.0.1:7682:7682"   # host only; browser terminal for CAI
__CYBERLAB_EOF__
chmod 0644 /opt/cyberlab/docker-compose.cai.yml
install -d -m 0755 "$(dirname /usr/local/bin/cyberlab)"
cat > /usr/local/bin/cyberlab <<'__CYBERLAB_EOF__'
#!/usr/bin/env bash
# cyberlab - manage the segmented Docker lab
# Usage: cyberlab {up|verify|status|alerts|rules|scan <target>|cai|reset [--full]|down|destroy}
set -uo pipefail

LAB_DIR="${LAB_DIR:-/opt/cyberlab}"
DC="docker compose --project-directory $LAB_DIR -f $LAB_DIR/docker-compose.yml"
# Optional local overrides (for example a pre-baked attacker image on offline Proxmox pods)
[ -f "$LAB_DIR/docker-compose.override.yml" ] && DC="$DC -f $LAB_DIR/docker-compose.override.yml"
# Optional CAI agent: included automatically once an API-key file exists
[ -f "$LAB_DIR/cai/cai.env" ] && [ -f "$LAB_DIR/docker-compose.cai.yml" ] && DC="$DC -f $LAB_DIR/docker-compose.cai.yml"

wait_for_log() {   # container, text, timeout-seconds
  local c="$1" text="$2" t="${3:-600}" i=0
  printf "[wait] %s " "$c"
  until docker logs "$c" 2>&1 | grep -q "$text"; do
    sleep 5; i=$((i+5)); printf "."
    [ "$i" -ge "$t" ] && { echo " timeout"; return 1; }
  done
  echo " ok"
}

update_rules() {
  echo "[rules] downloading Emerging Threats Open rules into Suricata"
  docker exec suricata suricata-update -q && docker restart suricata >/dev/null && echo "[rules] loaded"
}

cmd_up() {
  $DC pull -q --ignore-pull-failures || echo "[up] some images could not be pulled; using local copies"
  echo "[up] building the attacker image (Kali + XFCE/XRDP; first build is slow)"
  $DC build attacker || { echo "[up] attacker image build failed"; return 1; }
  $DC up -d
  wait_for_log router "router ready" 120
  wait_for_log attacker "attacker ready" 900   # desktop image build/boot can take several minutes
  if ! docker exec suricata test -s /var/lib/suricata/rules/suricata.rules 2>/dev/null; then
    update_rules
  fi
  if docker ps --format '{{.Names}}' | grep -qx cai; then
    docker exec cai ip route replace 10.20.0.0/24 via 10.10.0.254 2>/dev/null || true
  fi
  cmd_status
  cat <<'EOF'

Lab is up.
  RDP desktop  : 127.0.0.1:3389   (user root / password cyberrange)   [GUI labs]
  Attack shell : docker exec -it attacker bash
  DNS (Lab 1)  : docker exec attacker dig @10.20.0.53 cipher.lab AXFR   (succeeds via NAT - that's the finding)
  Vuln scan    : cyberlab scan http://10.20.0.12
  IDS alerts   : cyberlab alerts
  Portainer    : https://localhost:9443   (create the admin user within 5 minutes)
  Browser      : SOCKS5 127.0.0.1:1080, then open http://10.20.0.11:3000 or http://10.20.0.12
  CAI (opt'l)  : cyberlab cai   (AI pentest agent; needs an API key in cai/cai.env)
  Self-test    : cyberlab verify
EOF
}

cmd_status() { $DC ps --format "table {{.Name}}\t{{.Status}}"; }

cmd_alerts() { docker exec -it suricata tail -n 30 -f /var/log/suricata/fast.log; }

check() {   # description, expected(pass|block), command...
  local desc="$1" expect="$2"; shift 2
  if "$@" >/dev/null 2>&1; then got=pass; else got=block; fi
  if [ "$got" = "$expect" ]; then echo "  PASS  $desc"; else echo "  FAIL  $desc (expected $expect, got $got)"; FAILS=$((FAILS+1)); fi
}

cmd_verify() {
  FAILS=0
  echo "Segmentation and service checks:"
  check "Internet -> Juice Shop 10.20.0.11:3000 allowed" pass docker exec attacker curl -s -m 5 -o /dev/null http://10.20.0.11:3000
  check "Internet -> DVWA 10.20.0.12:80 allowed"         pass docker exec attacker curl -s -m 5 -o /dev/null http://10.20.0.12
  check "Internet -> DVWA MySQL 3306 blocked"            block docker exec attacker nc -z -w 3 10.20.0.12 3306
  check "Internet -> LAN 10.30.0.20 blocked"             block docker exec attacker ping -c 1 -W 2 10.30.0.20
  check "Internet -> DNS 10.20.0.53 resolves cipher.lab" pass bash -c "docker exec attacker dig +time=3 +tries=1 @10.20.0.53 juiceshop.cipher.lab +short | grep -q 10.20.0.11"
  check "Zone transfer (AXFR) succeeds from attacker (NAT bypass)" pass bash -c "docker exec attacker dig +time=5 @10.20.0.53 cipher.lab AXFR | grep -q metasploitable"
  check "DMZ pivot (DVWA) -> Metasploitable FTP allowed" pass docker exec dvwa bash -c 'timeout 3 bash -c "</dev/tcp/10.30.0.20/21"'
  check "DMZ and LAN have no internet access"            block docker exec dvwa bash -c 'timeout 3 bash -c "</dev/tcp/1.1.1.1/443"'
  check "Suricata rules loaded"                          pass docker exec suricata test -s /var/lib/suricata/rules/suricata.rules
  check "Portainer bound to localhost only"              block bash -c "ss -ltn | grep ':9443' | grep -v 127.0.0.1"
  check "Attacker RDP bound to localhost only"           block bash -c "ss -ltn | grep ':3389' | grep -v 127.0.0.1"
  check "Nuclei installed in the attacker container"     pass  docker exec attacker sh -c "command -v nuclei"
  check "dig installed in the attacker container"        pass  docker exec attacker sh -c "command -v dig"

  echo "IDS detection check (sends a request with a sqlmap user agent):"
  docker exec attacker curl -s -m 5 -o /dev/null -A "sqlmap/1.8" "http://10.20.0.12/?id=1" || true
  sleep 8
  if docker exec suricata grep -qi sqlmap /var/log/suricata/fast.log 2>/dev/null; then
    echo "  PASS  Suricata raised a sqlmap alert"
  else
    echo "  WARN  no sqlmap alert yet; run 'cyberlab rules' and try again"
  fi
  [ "$FAILS" -eq 0 ] && echo "All checks passed." || { echo "$FAILS check(s) failed."; return 1; }
}

cmd_reset() {
  if [ "${1:-}" = "--full" ]; then
    echo "[reset] full: removing containers AND volumes (rules, logs, Portainer settings)"
    $DC down -v
  else
    echo "[reset] containers rebuilt from clean images; rules, logs and Portainer kept"
    $DC down
  fi
  cmd_up
}

cmd_scan() {
  local target="${1:-}"
  if [ -z "$target" ]; then
    echo "usage: cyberlab scan <target>     e.g. cyberlab scan http://10.20.0.12"
    echo "       LAN targets (10.30.0.x) need the dvwa pivot first."
    return 1
  fi
  echo "[scan] ensuring nuclei is present in the attacker container..."
  docker exec attacker bash -c 'command -v nuclei >/dev/null 2>&1 || { apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nuclei >/dev/null; }' \
    || { echo "[scan] could not install nuclei in the attacker container"; return 1; }
  docker exec attacker bash -c '[ -d "$HOME/nuclei-templates" ] || nuclei -update-templates >/dev/null 2>&1 || true'
  echo "[scan] running nuclei against $target"
  docker exec attacker nuclei -u "$target" -severity low,medium,high,critical -stats -no-color
}

cmd_cai() {
  if [ ! -f "$LAB_DIR/cai/cai.env" ]; then
    cp "$LAB_DIR/cai/cai.env.example" "$LAB_DIR/cai/cai.env"
    chmod 600 "$LAB_DIR/cai/cai.env"
    echo "[cai] created $LAB_DIR/cai/cai.env - add your API key (OPENAI_API_KEY or ANTHROPIC_API_KEY),"
    echo "[cai] then run 'cyberlab cai' again to build and start the agent."
    return 0
  fi
  echo "[cai] building and starting the CAI agent (first build is slow)..."
  $DC up -d --build cai || { echo "[cai] failed to start CAI"; return 1; }
  docker exec cai ip route replace 10.20.0.0/24 via 10.10.0.254 2>/dev/null || true
  echo "[cai] up. Browser: http://127.0.0.1:7682   or:  docker exec -it cai cai"
  echo "[cai] scope: DMZ 10.20.0.0/24 (reach 10.30.0.20 only via the dvwa pivot)."
}

case "${1:-}" in
  up)      cmd_up ;;
  verify)  cmd_verify ;;
  status)  cmd_status ;;
  alerts)  cmd_alerts ;;
  rules)   update_rules ;;
  scan)    cmd_scan "${2:-}" ;;
  cai)     cmd_cai ;;
  reset)   cmd_reset "${2:-}" ;;
  down)    $DC stop ;;
  destroy) $DC down -v --rmi all ;;
  *) echo "Usage: cyberlab {up|verify|status|alerts|rules|scan <target>|cai|reset [--full]|down|destroy}"; exit 1 ;;
esac
__CYBERLAB_EOF__
chmod 0755 /usr/local/bin/cyberlab

# --- install ---------------------------------------------------------------
bash "$TMP/install-docker.sh" "$LAB_USER"
# (local host: no cloud hardening)
echo "[cyberlab] starting the lab (first run builds the desktop image and downloads about 3 GB)"
cyberlab up
cyberlab verify || echo "[cyberlab] some checks failed; rerun 'cyberlab verify' in a few minutes"
rm -rf "$TMP"
echo "[cyberlab] bootstrap done $(date -u +%FT%TZ). Log out and back in, then run: cyberlab verify"
echo "[cyberlab] GUI labs: RDP to 127.0.0.1:3389 (root / cyberrange).  CLI: docker exec -it attacker bash"
