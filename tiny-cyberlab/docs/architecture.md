# Architecture

![Tiny CyberLab topology](topology.png)

Tiny CyberLab (TCL) is deliberately small: one virtual machine, one Docker
network, a handful of containers.

## Layers

1. **Host VM** — Ubuntu Server running in Oracle VirtualBox. It needs Docker
   Engine and the Compose plugin and enough RAM/CPU for the containers (the
   attacker desktop image is the heaviest). Give it a host-only or bridged
   adapter so you can reach the published ports as `<lab-host-ip>`.
2. **Docker bridge network** — `cyberlab_net`, subnet `10.30.0.0/24`, gateway
   `10.30.0.1`. Containers resolve each other by name (Docker's embedded DNS),
   so labs can target `juice-shop` or `10.30.0.20` interchangeably.
3. **Containers** — one attacker workstation plus the targets and sensors the
   labs need.

## Hosts

| Container | Reference IP | Image | Purpose |
| --- | --- | --- | --- |
| `attacker` | 10.30.0.10 | `kalilinux/kali-rolling` + XFCE/XRDP (built locally) | Student workstation; all offensive tools; GUI desktop over RDP |
| `dns` | 10.30.0.53 | BIND 9 | Authoritative for `cipher.lab`; AXFR allowed only from `victim` |
| `juice-shop` | 10.30.0.20 | `bkimminich/juice-shop` | Modern web app target (port 3000) |
| `dvwa` | 10.30.0.21 | `vulnerables/web-dvwa` | Classic vulnerable web app (port 80) |
| `victim` | 10.30.0.30 | `tleemcjr/metasploitable2` | Vulnerable Linux; exploitation, MITM, backdoor labs |
| `ids` | 10.30.0.40 | `jasonish/suricata` | IDS sensor for the evasion lab |
| `caldera` | 10.30.0.50 | MITRE Caldera | Adversary emulation (port 8888) |

> IPs are the **reference layout**. The labs also work by container name, so a
> drifted address does not break them. Confirm live values with `docker ps` and
> `docker network inspect cyberlab_net`.

## Access paths (published from the host)

| Port | Service | Used for |
| --- | --- | --- |
| 3389 | attacker XRDP desktop | GUI labs (Zenmap, Armitage, Burp, Wireshark, Ettercap) |
| 7681 | attacker ttyd | browser terminal (CLI labs) |
| 2222 | attacker SSH | terminal (CLI labs) |
| 8888 | Caldera UI | adversary-emulation work |

## Isolation model
Everything lives inside the host VM. Only the attacker (and optionally Caldera)
ports are published, and only to the host. Nothing in the range is reachable from
outside the VM, which is what makes the offensive labs safe to run. Do **not**
attach `cyberlab_net` to an external network. See [DISCLAIMER.md](../DISCLAIMER.md).

## Capabilities
The attacker container runs with `NET_ADMIN` and `NET_RAW` so Scapy, hping3, and
Ettercap can craft and inject packets, and with extra shared memory for the GUI
apps. These are scoped to the lab and documented in `range/docker-compose.yml`.
