# Changelog

All notable changes to Tiny CyberLab (TCL) are documented here. Format based on
[Keep a Changelog](https://keepachangelog.com/); versioning is
[SemVer](https://semver.org/).

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
  desktop), BIND `cipher.lab` zone, and `docker-compose.yml` defining the
  `cyberlab_net` (10.30.0.0/24) with dns, juice-shop, dvwa, victim, ids, and
  caldera containers.
- 18 NICE-aligned lab exercises (`labs/`).
- Documentation set (`docs/`): topology, architecture, instructor guide,
  student quick-start, NICE mapping, research context.
