# Architecture

![Tiny CyberLab topology](topology.png)

Tiny CyberLab (TCL) runs a **segmented** teaching range — Internet, DMZ, and an
internal LAN behind a firewall router — as a handful of Docker containers on a
single virtual machine. The segmentation is the point: students practise reaching
services through a firewall and pivoting to an internal host, not just scanning a
flat subnet.

## Layers

1. **Host VM** — Kali or Ubuntu Server in Oracle VirtualBox. It needs Docker
   Engine and the Compose plugin and enough RAM/CPU for the containers (the
   attacker desktop image is the heaviest). **Linux host networking is required**
   so the Suricata sensor can sniff the lab bridges.
2. **Three Docker networks**
   - `internet` — bridge `br-inet`, `10.10.0.0/24`. Normal bridge with outbound NAT.
   - `dmz` — bridge `br-dmz`, `10.20.0.0/24`, **`internal: true`** (no direct route out).
   - `lan` — bridge `br-lan`, `10.30.0.0/24`, **`internal: true`**.
   - `mgmt` — Portainer only.
   Containers resolve each other by name via the BIND server for `cipher.lab`.
3. **Containers** — the attacker, a firewall router, the targets, and a sensor.

## Hosts

| Zone | Container | Reference IP | Image | Purpose |
| --- | --- | --- | --- | --- |
| Internet | `attacker` | 10.10.0.10 | `kalilinux/kali-rolling` + XFCE/XRDP (built locally) | Student workstation; offensive tools; GUI desktop over RDP |
| Internet/DMZ | `router` | 10.10.0.254 · 10.20.0.254 | `alpine` + iptables | Firewall / NAT between the Internet and the DMZ |
| DMZ | `juiceshop` | 10.20.0.11 | `bkimminich/juice-shop` | Modern web app target (port 3000) |
| DMZ | `dvwa` | 10.20.0.12 · 10.30.0.12 | `vulnerables/web-dvwa` | Vulnerable web app (port 80); **dual-homed LAN pivot** |
| DMZ | `dns` | 10.20.0.53 | BIND 9 | Authoritative for `cipher.lab` |
| LAN | `metasploitable` | 10.30.0.20 | `tleemcjr/metasploitable2` | Vulnerable Linux; exploitation, enumeration, backdoor labs |
| host net | `suricata` | br-inet + br-lan | `jasonish/suricata` | IDS sensor; `HOME_NET` = DMZ + LAN |
| mgmt | `portainer` | 127.0.0.1:9443 | `portainer-ce` | Container management GUI |

> IPs are the **reference layout**. The labs also work by container name, so a
> drifted address does not break them. Confirm live values with `docker ps`,
> `docker network inspect br-dmz`, and `docker network inspect br-lan`.

## Firewall policy (the `router`)
The router forwards traffic **Internet → DMZ** for:

- TCP `80` and `3000` (the web apps)
- TCP/UDP `53` (DNS)
- ICMP (ping)

Everything else is dropped (`FORWARD` policy `DROP`, with `ESTABLISHED,RELATED`
allowed back). Outbound DMZ replies work because the router **source-NATs** traffic
into the DMZ — a detail that matters in Lab 1, where it lets the attacker bypass a
DMZ-only zone-transfer ACL. The **LAN has no forward rule at all**, so it is
reachable only by pivoting through the dual-homed `dvwa`.

## Access paths (published from the host, loopback only)

| Bind | Service | Used for |
| --- | --- | --- |
| 127.0.0.1:3389 | attacker XRDP desktop | GUI labs (Zenmap, Armitage, Burp, Wireshark, Ettercap) |
| `docker exec -it attacker bash` | attacker shell | CLI labs |
| 127.0.0.1:1080 | SOCKS5 (shares the attacker's stack) | pointing a host browser at the DMZ |
| 127.0.0.1:9443 | Portainer | container management / reading Suricata logs |

## Isolation model
Everything lives inside the host VM. The DMZ and LAN networks are `internal` (no
route off-box), and the only published ports are bound to `127.0.0.1`. Nothing in
the range is reachable from outside the VM, which is what makes the offensive labs
safe to run. For remote students, tunnel RDP over a VPN/SSH rather than publishing
it. See [DISCLAIMER.md](../DISCLAIMER.md).

## Capabilities
The attacker runs with `NET_ADMIN` and `NET_RAW` so Scapy, hping3, and Ettercap can
craft and inject packets, and with extra shared memory for the GUI apps. The router
holds `NET_ADMIN` and enables `ip_forward`; Suricata holds `NET_ADMIN`, `NET_RAW`,
and `SYS_NICE`. All are scoped to the lab and documented in
`range/docker-compose.yml`.
