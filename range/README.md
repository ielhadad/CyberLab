# Tiny CyberLab (TCL) — build kit

Reference topology the 18 TCL lab exercises are written against. Run it on the
Ubuntu Server host (the VirtualBox VM).

## Quick start
```bash
cd range-kit
docker compose build attacker
docker compose up -d
docker ps
docker network inspect cyberlab_net   # confirm the 10.30.0.x addresses
```

## Attacker access
- **RDP desktop (GUI labs):** point any Remote Desktop client at `<lab-host-ip>:3389`
  (Windows: *Remote Desktop Connection*; macOS: *Windows App / Microsoft Remote Desktop*;
  Linux: Remmina). Log in **root / cyberrange** — you land on the Kali XFCE desktop with
  Zenmap, Armitage, Burp Suite, Wireshark, and Ettercap already installed.
- ttyd browser terminal:  http://<lab-host-ip>:7681
- SSH:                     ssh root@<lab-host-ip> -p 2222   (password: cyberrange)
- From the host:          docker exec -it attacker bash

`<lab-host-ip>` is the Ubuntu Server VM's address. If the VM uses a NAT adapter only,
add a VirtualBox port-forward (Host 3389 -> Guest 3389) and RDP to `127.0.0.1:3389`.

## Containers (reference IPs on cyberlab_net / 10.30.0.0/24)
| host | ip | used by |
|---|---|---|
| attacker | 10.30.0.10 | every lab |
| dns | 10.30.0.53 | Lab 1 |
| juice-shop | 10.30.0.20 | Labs 2,3,4,6,8 |
| dvwa | 10.30.0.21 | Labs 9,10,14 |
| victim (Metasploitable 2) | 10.30.0.30 | Labs 1,5,6,7,9,12,15,16 |
| ids (Suricata) | 10.30.0.40 | Lab 7 |
| caldera | 10.30.0.50 | adversary emulation |

## Notes / things to adjust for your environment
- IMAGE TAGS: `tleemcjr/metasploitable2`, `jasonish/suricata`, the BIND and
  Caldera images are community images — swap for the ones you already use if
  different. The labs target containers by **name** too (e.g. `nmap victim`),
  so exact IPs are not critical.
- GUI tools (Zenmap, Armitage, Burp, Wireshark GUI, Ettercap -G): the attacker
  image already includes an XFCE desktop over XRDP, so connect by RDP (above) and
  run them there — no separate Kali VM needed. If a GUI package name is missing in
  your mirror, drop it from the attacker Dockerfile's last RUN and rebuild; the CLI
  equivalents (msfconsole, tshark, ettercap -T, nmap) still work headless.
- XRDP lands on an XFCE session for root (/root/.xsession = xfce4-session). If you
  add non-root lab users, give each the same .xsession. The desktop image is large;
  the first `docker compose build attacker` can take 10-20 minutes.
- OpenVAS (Lab 5): install on demand inside the attacker — it is large.
  `apt-get install -y gvm && gvm-setup && gvm-start`
- Lab 16 (VNC backdoor) needs a VNC server on `victim`; Metasploitable already
  ships one, or add `x11vnc`/`tightvncserver` to that image.
- `cap_add: NET_ADMIN/NET_RAW` on the attacker is required for Scapy, hping3,
  and Ettercap to craft/inject packets.
