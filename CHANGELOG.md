# Changelog

All notable changes to Tiny CyberLab (TCL) are documented here. Format based on
[Keep a Changelog](https://keepachangelog.com/); versioning is
[SemVer](https://semver.org/).

## [2.0.0] - 2026-10-03
### Changed
- **Re-aligned the whole project to a segmented range.** The flat `10.30.0.0/24`
  network is replaced by three zones behind a firewall router: Internet
  (`10.10.0.0/24`, attacker + router), DMZ (`10.20.0.0/24`, web apps + DNS), and an
  internal LAN (`10.30.0.0/24`, metasploitable). The firewall forwards only web
  ports, DNS, and ICMP into the DMZ; the LAN is reachable only by pivoting through
  the dual-homed `dvwa`.
- All 26 labs retargeted to the new topology, with a per-lab *Reaching the target*
  box and a pivot note on the LAN labs (5, 9, 15, 16, 20, 21).
- Attacker access is now RDP (`127.0.0.1:3389`) + `docker exec`; the ttyd/SSH entry
  points were removed.
- Lab 1 (DNS) now teaches a NAT-bypass of a DMZ-only zone-transfer ACL instead of a
  simple refused/allowed contrast.
- Lab 6 (capture) and Lab 7 (IDS evasion) retargeted to the reachable DMZ; Suricata
  is read via `docker logs`/Portainer.
- Added a BIND DNS container to the range; dropped the Caldera container.
- Docs (README, architecture, student quick-start, instructor guide) rewritten for
  the segmented design; added a pivoting primer. Answer key updated (v2.0).

## [1.2.0] - 2026-10-02
### Added
- Eight more labs (19-26), converted from NDG Ethical Hacking v2 to the TCL
  structure with all three activity tracks: Scanning Methodology, Enumeration,
  System Hacking, Windows SAM/Registry, Covering Your Tracks, Web-Based Hacking,
  Mobile Hacking, and Cryptography. The series is now 26 labs.
- Answer key extended to cover labs 19-26.

## [1.1.0] - 2026-10-02
### Added
- Each lab's activities now come in three tracks: **Guided** (commands + expected
  output + practice), **Unguided** (objectives + hints), and **Capture the Flag**
  (point-scored flags, no instructions). Section 6 renamed "Lab Activities".

## [1.0.0] - 2026-10-02
### Added
- Initial public release.
- Reference range topology (`range/`): attacker image (Kali tools + XFCE/XRDP
  desktop), BIND `cipher.lab` zone, and `docker-compose.yml`. *(The 1.0 release used
  a single flat `10.30.0.0/24` network; see 2.0.0 for the segmented redesign.)*
- 18 NICE-aligned lab exercises (`labs/`).
- Documentation set (`docs/`): topology, architecture, instructor guide,
  student quick-start, NICE mapping, research context.
