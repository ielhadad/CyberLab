# Adding an XRDP desktop to the CyberLab attacker

A few labs need GUI tools (Burp Suite, Wireshark, Zenmap, Ettercap, a browser).
This lab does **not** use Guacamole — instead we give the **attacker container** a
light XFCE desktop served over **XRDP**, and students reach it with any Remote
Desktop client. The desktop runs inside the attacker, so GUI tools still reach the
DMZ through the router exactly as the CLI tools do.

## What changes
| Item | Value |
| --- | --- |
| Attacker image | custom build (`./attacker/Dockerfile`) = Kali tools + XFCE + XRDP |
| New port | `3389` published on the attacker (host-only by default) |
| Login | `root` / `cyberrange` |
| Memory | raised to `3g` + `shm_size: 1g` (desktop + browser) |

Files in this drop-in:
- `attacker/Dockerfile` — the custom attacker image
- `docker-compose.yml` — your compose with the `attacker:` service patched

## Install
From the CyberLab directory (e.g. `/opt/cyberlab`):

```bash
# 1. Put the two files in place
#    - attacker/Dockerfile   (new folder)
#    - docker-compose.yml    (replaces the current one; back up the old one first)
cp docker-compose.yml docker-compose.yml.bak

# 2. Build the attacker image and (re)start just that service
sudo docker compose build attacker
sudo docker compose up -d attacker

# 3. Confirm XRDP is listening inside the container
sudo docker exec attacker ss -tlnp | grep 3389
```

The first build pulls the desktop packages, so it takes a while; after that,
starts are fast (unlike installing the desktop at runtime every time).

## Connect
From the Kali host, open any RDP client and connect to:

```
127.0.0.1:3389      (user: root   password: cyberrange)
```

You land on the XFCE desktop with Firefox and your GUI tools. Verify lab reach
from a terminal on that desktop:

```bash
curl -s http://10.20.0.11:3000 >/dev/null && echo "juiceshop reachable"
nmap -sn 10.20.0.0/24
```

## Choices
- **Who connects.** `127.0.0.1:3389:3389` keeps RDP **host-only**, matching the
  lab's "nothing on a public interface" design — students RDP from the Kali host
  itself. If students connect from their **own machines**, change that line in
  `docker-compose.yml` to `"3389:3389"` (all interfaces) or bind it to the host's
  LAN IP, and treat it as an exposed service.
- **Which GUI tools.** Add what your labs need to the apt line in
  `attacker/Dockerfile`, e.g. `wireshark zaproxy ettercap-graphical`.
- **Non-root student user.** Root-over-RDP works via the `~/.xsession` + the
  colord polkit rule baked into the image. To have students log in as a non-root
  user, create one in the Dockerfile and give it the same `~/.xsession`.

## Troubleshooting
- **Black screen / instant logout:** `~/.xsession` must contain `xfce4-session`
  (already set in the image).
- **"Authentication required to create a color managed device" loop:** fixed by
  the colord polkit rule in the image.
- **Can't reach the DMZ from the desktop:** the `ip route replace 10.20.0.0/24 via
  10.10.0.254` line in the attacker `command:` must run — check the container logs
  (`docker logs attacker`).
- **Port already in use on the host:** change the host side, e.g.
  `"127.0.0.1:3390:3389"`, and connect to `127.0.0.1:3390`.
