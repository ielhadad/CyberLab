# CyberLab — Bootstrap Scripts

One-command installers that stand up the **segmented CyberLab** (Internet / DMZ / LAN
behind a firewall, XRDP attacker desktop, BIND DNS, Suricata IDS, Portainer, optional
CAI agent) on a single Linux host. Each script is **self-contained** — it writes
everything it needs under `/opt/cyberlab` and installs a `cyberlab` management command.
You do **not** need to clone the repo to use these.

> ⚠️ Authorized, contained lab use only — these install real offensive tooling. Only
> attack the hosts inside the range. Nothing is exposed to the public internet.

## What's in this bundle

| Script | Use it for | Extras |
| --- | --- | --- |
| `bootstrap-local.sh` | A **local** host — a VirtualBox/Proxmox Kali or Ubuntu Server VM | — |
| `bootstrap-vps.sh` | **Any cloud / VPS** (AWS EC2, DigitalOcean, Lightsail, Hetzner…) | swap, SSH-only firewall (ufw), fail2ban, automatic security updates |
| `hcloud-launch.sh` | Launch a **Hetzner Cloud** server and run `bootstrap-vps.sh` on it automatically | creates the server, SSH key, and SSH-only cloud firewall |

`bootstrap-local.sh` and `bootstrap-vps.sh` are the same range; the VPS one just adds
cloud hardening. `hcloud-launch.sh` is a thin launcher that feeds `bootstrap-vps.sh` to a
new Hetzner box as cloud-init.

## Requirements

- A 64-bit **x86** host (the target images DVWA/Metasploitable are x86-only — **no
  Arm/Apple-silicon/Hetzner-CAX**).
- **8 GB RAM minimum, 16 GB recommended** (the attacker is a Kali + XFCE/XRDP desktop
  image), and ~50–60 GB free disk.
- Ubuntu Server 24.04 or Kali, with internet access for the first build (~3 GB pull).
- Linux host networking (required for the Suricata sensor) — i.e. a real Linux host/VM,
  not Docker Desktop on macOS/Windows.

## Usage

### Local VM
```bash
sudo bash bootstrap-local.sh
```

### Cloud / VPS
Paste `bootstrap-vps.sh` as the instance's **user-data / cloud-init**, or SSH in and run:
```bash
sudo bash bootstrap-vps.sh
```
Open **only** SSH (port 22) to your IP in the provider's firewall. Everything else is
bound to `127.0.0.1` and reached over an SSH tunnel (see Access, below).

### Hetzner Cloud (one command)
Needs the `hcloud` CLI configured (`hcloud context create cyberlab`) and an SSH key
(`ssh-keygen -t ed25519`). Run it from the folder that holds `bootstrap-vps.sh`:
```bash
bash hcloud-launch.sh nbg1 bootstrap-vps.sh
```
Defaults to a `cx43` (16 GB) x86 server; override with `HCLOUD_TYPE=cx33` for the 8 GB
minimum. The script prints the IP and the exact SSH-tunnel command when it's done.

## Managing the range (the `cyberlab` command)

```text
cyberlab up        # build + start, then print access info
cyberlab verify    # self-test: segmentation, DNS, pivot, IDS and service checks
cyberlab status    # container status
cyberlab alerts    # tail Suricata alerts
cyberlab scan URL  # run a nuclei scan from the attacker (e.g. cyberlab scan http://10.20.0.12)
cyberlab cai       # OPTIONAL: enable the CAI AI-pentest agent (needs an API key)
cyberlab reset     # recreate containers (add --full to also wipe volumes)
cyberlab down      # stop everything
cyberlab destroy   # remove containers, volumes and images
```

## Access the attacker

| Method | How | Use |
| --- | --- | --- |
| RDP desktop | **local:** RDP client → `127.0.0.1:3389`  ·  **cloud:** tunnel first, then RDP to `127.0.0.1:3389` | GUI labs |
| Terminal | `docker exec -it attacker bash` | CLI labs |

Desktop login is **root / cyberrange**. On a cloud/VPS host, open the tunnel on your
laptop first:
```bash
ssh -L 3389:127.0.0.1:3389 -L 9443:127.0.0.1:9443 <user>@<PUBLIC_IP>
# add -L 7682:127.0.0.1:7682 if you enabled CAI
```
Then point your Remote Desktop client at `127.0.0.1:3389`. Portainer is at
`https://127.0.0.1:9443` through the same tunnel.

## The range at a glance

```text
Internet 10.10.0.0/24   attacker 10.10.0.10  ---  router 10.10.0.254
DMZ      10.20.0.0/24   juiceshop .11 (3000) · dvwa .12 (80) · dns .53   (fw: 80/3000/53/icmp)
LAN      10.30.0.0/24   metasploitable .20   (reached only via the dual-homed dvwa pivot)
```

## Optional: the CAI agent

`cyberlab cai` enables an AI-assisted pentest agent (CAI). The first run creates
`/opt/cyberlab/cai/cai.env`; add an `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`, then run
`cyberlab cai` again to build and start it. It stays **off** until you supply a key.

## Notes

- First `up` is slow: it builds the Kali + XFCE/XRDP attacker image and pulls ~3 GB.
- Re-running a bootstrap script is safe (idempotent).
- Progress log: `/var/log/cyberlab-bootstrap.log`.
- `cyberlab verify` should end with "All checks passed." — if not, give it a few minutes
  (first boot installs Suricata rules) and run it again.
