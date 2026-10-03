# TCL Labs

Twenty-six instructor-authored labs for Tiny CyberLab. Each follows the same
eight-section structure — Introduction & Objectives, NICE Role Alignment, Network
Topology, Learning Outcomes, Case Scenario, Lab Activities, Deliverable, and
Additional Resources — and is framed as a task in a fictional engagement (Summit
Cyber Group assessing Cipher Logistics). All labs run inside the **segmented
range** — Internet (`10.10.0.0/24`), DMZ (`10.20.0.0/24`), and LAN
(`10.30.0.0/24`) behind a firewall router; see the root [README](../README.md) and
[`docs/`](../docs). Labs marked **(pivot)** target the LAN host through the
dual-homed `dvwa`.

## Three ways to run each lab
Every lab's **Lab Activities** section offers the same exercise at three levels of
support, so you can scaffold from worked example to independent mastery:

- **6A — Guided Lab:** step-by-step with the exact commands and an "Expected"
  checkpoint after each, plus a short *Practice* task to try alone. (*I do / we do.*)
- **6B — Unguided Lab:** the same objectives with the commands removed and a
  **Hints** box for when students get stuck. (*You do.*)
- **6C — Capture the Flag:** a game-style scenario with point-scored flags and
  **no instructions** — students choose their own tools. (*Prove it.*)

Run them as a progression across a unit, or assign the single track that fits the
class.

> All labs are **authorized, contained** exercises. See [DISCLAIMER.md](../DISCLAIMER.md).

| # | Lab | Primary tools | Main target(s) | NICE work role |
|---|-----|---------------|----------------|----------------|
| 01 | DNS Reconnaissance | nslookup, dig, host | `dns` (DMZ) | Vulnerability Analysis |
| 02 | Packet Crafting with Scapy | Scapy, tcpdump | `juiceshop` (DMZ) | Vulnerability Analysis |
| 03 | Reconnaissance with Nmap, Zenmap & Masscan | Nmap, Zenmap, Masscan | `juiceshop` + DMZ subnet | Vulnerability Analysis |
| 04 | Reconnaissance with hping | hping3, tcpdump | `juiceshop`, `router` | Vulnerability Analysis |
| 05 | Vulnerability Scanning with OpenVAS | OpenVAS/Greenbone | `metasploitable` **(pivot)** | Vulnerability Analysis |
| 06 | Network Analysis | tcpdump, Wireshark, dig/curl | `dns`, `juiceshop`, `dvwa` (DMZ) | Vulnerability Analysis |
| 07 | Evading IDS | Nmap evasion, Suricata | `dvwa` (DMZ); Suricata sensor | Vulnerability Analysis |
| 08 | Password Cracking with John & Hashcat | CeWL, Crunch, John, Hashcat | attacker (local hashes) | Vulnerability Analysis |
| 09 | Metasploit Framework & Armitage | Metasploit, WMAP, Armitage | `metasploitable` **(pivot)** | Vulnerability Analysis |
| 10 | Web Pentesting | Nikto, Burp Suite | `dvwa` (DMZ) | Vulnerability Analysis |
| 11 | Client-Side Exploitation with BeEF | BeEF | attacker + its browser | Vulnerability Analysis |
| 12 | ARP Spoofing & MITM | Ettercap | LAN segment (see lab note) | Vulnerability Analysis |
| 13 | Understanding Buffer Overflows | gcc, editor | attacker (local) | Vulnerability Analysis |
| 14 | SQL Commands & Injections | MySQL, sqlmap | `dvwa` (DMZ) | Vulnerability Analysis |
| 15 | Backdooring with Netcat | Netcat | `metasploitable` **(pivot)** | Vulnerability Analysis |
| 16 | VNC as a Backdoor | TightVNC, x11vnc | `metasploitable` **(pivot)** | Vulnerability Analysis |
| 17 | Creating & Installing SSL Certificates | OpenSSL, Apache | attacker (local) | Vulnerability Analysis |
| 18 | Social Engineering with SET | Social-Engineer Toolkit | attacker + its browser | Vulnerability Analysis |
| 19 | Scanning Methodology | Nmap, hping3, Nikto | DMZ subnet, `juiceshop`, `dvwa` | Vulnerability Analysis |
| 20 | Enumeration | enum4linux, Nmap NSE, rpcclient | `metasploitable` **(pivot)** | Vulnerability Analysis |
| 21 | System Hacking | msfvenom, Meterpreter | `metasploitable` **(pivot)** | Vulnerability Analysis |
| 22 | Windows SAM & Registry Credential Extraction | samdump2, John | attacker (supplied hives) | Vulnerability Analysis |
| 23 | Covering Your Tracks | xattr, OpenStego, logs | attacker (local) | Vulnerability Analysis |
| 24 | Web-Based Hacking | Vega, Burp | `dvwa`, `juiceshop` (DMZ) | Vulnerability Analysis |
| 25 | Mobile Hacking | msfvenom (APK), Meterpreter | attacker (+ Android add-on) | Vulnerability Analysis |
| 26 | Cryptography | OpenSSL, gpg, sha256sum | attacker (local) | Vulnerability Analysis |

## Instructor answer key
A password-protected **Instructor Answer Key & Grading Guide** (CTF flag answers,
guided checkpoints, grading notes) is available to verified instructors only — see
[INSTRUCTOR-ACCESS.md](INSTRUCTOR-ACCESS.md). It is intentionally not committed here.

## Format
Labs ship as `.docx` so instructors can edit them in Word/LibreOffice and export
to PDF for distribution. The files are dual-use: assign them as-is, or lift the
Case Scenario and Deliverable into your LMS.

## Suggested sequence
Labs are ordered along the assessment lifecycle — footprinting and scanning
(01–04), vulnerability analysis (05–06), evasion (07), credential and
exploitation work (08–10), client-side and on-path attacks (11–12), root-cause
and web application topics (13–14), persistence and backdoors (15–16), and
defensive/awareness topics (17–18). Run them in order or pick to match your
syllabus.
