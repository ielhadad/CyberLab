# CyberLab — build kit (segmented range)

A segmented Internet / DMZ / LAN range on a single Docker host: a firewall
router, a Kali attacker with an XFCE-over-RDP desktop, DMZ web apps, a DNS
server, a LAN victim reachable only by pivoting, Suricata IDS, and Portainer.

## Quick start
```bash
cd range
docker compose build attacker          # Kali + desktop image; first build is slow
docker compose up -d
docker ps
```

## Topology
| Segment | Subnet | Hosts |
| --- | --- | --- |
| internet | 10.10.0.0/24 (br-inet) | attacker 10.10.0.10, router 10.10.0.254 |
| dmz | 10.20.0.0/24 (br-dmz, internal) | router 10.20.0.254, juiceshop 10.20.0.11, dvwa 10.20.0.12, dns 10.20.0.53 |
| lan | 10.30.0.0/24 (br-lan, internal) | dvwa 10.30.0.12 (dual-homed pivot), metasploitable 10.30.0.20 |
| mgmt | — | portainer (host-only 9443) |

- The **router** firewall lets the attacker reach the DMZ on **80, 3000, 53, and ICMP** only.
- **metasploitable** (LAN) is reachable only by **pivoting through dvwa** (dual-homed).
- **Suricata** runs on the host network, sniffing `br-inet` + `br-lan` (HOME_NET = DMZ+LAN).

## Access the attacker
| Method | Address |
| --- | --- |
| RDP desktop (GUI labs) | `127.0.0.1:3389` (root / cyberrange) |
| Shell | `docker exec -it attacker bash` |
| SOCKS proxy (host browser → DMZ) | `127.0.0.1:1080` |
| Portainer | `https://127.0.0.1:9443` |

`127.0.0.1` bindings keep everything host-only. For students on other machines,
change the attacker's `3389:3389` binding (and treat it as exposed).

## Notes
- Community image tags (`tleemcjr/metasploitable2`, `jasonish/suricata`, the BIND
  and Portainer images) can move — pin to versions you trust.
- GUI tools go on the attacker desktop; add what your labs need to
  `attacker/Dockerfile`. OpenVAS (Lab 05) installs on demand (it's large).
- Optional CAI agent: see [../docs/add-cai-container.md](../docs/add-cai-container.md).
