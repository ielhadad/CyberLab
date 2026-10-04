# NICE Workforce Framework Mapping

All 30 CyberLab labs are mapped to the **NICE Workforce Framework for Cybersecurity**
(NIST SP 800-181). Each lab is assigned a **primary work role** and **NICE category**
(these now appear in each lab's Section 2) plus **related roles** it also exercises.

> **Work-role ID codes must be verified** against the current NICE catalog before
> publication. The category assignments are stable; the specific WRL numbers below are
> best-effort and marked *(verify)*.

## Lab-to-role mapping

| # | Lab | Primary work role | NICE category | Related roles |
|---|-----|-------------------|---------------|---------------|
| 01 | DNS Reconnaissance & Zone-Transfer Testing | Vulnerability Analysis | Protection & Defense | Penetration Testing; Threat Analysis |
| 02 | Packet Crafting with Scapy | Penetration Testing | Cyberspace Effects | Vulnerability Analysis |
| 03 | Network Mapping (Nmap, Zenmap, Masscan) | Vulnerability Analysis | Protection & Defense | Penetration Testing |
| 04 | Packet Probing with hping3 | Vulnerability Analysis | Protection & Defense | Penetration Testing |
| 05 | Vulnerability Scanning with OpenVAS | Vulnerability Analysis | Protection & Defense | Systems Security Analysis |
| 06 | Traffic Analysis (tcpdump, Wireshark) | Defensive Cybersecurity | Protection & Defense | Digital Forensics |
| 07 | Evading an IDS | Penetration Testing | Cyberspace Effects | Defensive Cybersecurity |
| 08 | Password Cracking (John, Hashcat) | Penetration Testing | Cyberspace Effects | Vulnerability Analysis |
| 09 | Exploitation with Metasploit | Exploitation Analysis | Cyberspace Effects | Penetration Testing |
| 10 | Web Application Testing (Nikto, Burp) | Penetration Testing | Cyberspace Effects | Secure Software Development |
| 11 | Browser Exploitation with BeEF | Exploitation Analysis | Cyberspace Effects | Penetration Testing |
| 12 | ARP-Spoofing MITM | Penetration Testing | Cyberspace Effects | Defensive Cybersecurity |
| 13 | Buffer Overflow | Secure Software Development | Design & Development | Exploitation Analysis |
| 14 | SQL Injection | Secure Software Development | Design & Development | Penetration Testing |
| 15 | Netcat Backdoor | Penetration Testing | Cyberspace Effects | Defensive Cybersecurity |
| 16 | Reverse VNC Backdoor | Penetration Testing | Cyberspace Effects | Defensive Cybersecurity |
| 17 | SSL/TLS Certificates | Secure Software Development | Design & Development | Systems Security Analysis |
| 18 | Phishing with SET | Penetration Testing | Cyberspace Effects | Threat Analysis |
| 19 | Scanning Methodology | Vulnerability Analysis | Protection & Defense | Penetration Testing |
| 20 | SMB Enumeration | Vulnerability Analysis | Protection & Defense | Penetration Testing |
| 21 | Shell & Privilege Escalation | Penetration Testing | Cyberspace Effects | Exploitation Analysis |
| 22 | Windows SAM Cracking | Penetration Testing | Cyberspace Effects | Digital Forensics |
| 23 | Covering Tracks | Digital Forensics | Investigation | Incident Response |
| 24 | Web Hacking & Cookie Forgery | Penetration Testing | Cyberspace Effects | Secure Software Development |
| 25 | Android Hacking | Exploitation Analysis | Cyberspace Effects | Penetration Testing |
| 26 | Cryptography (CLI) | Secure Software Development | Design & Development | Systems Security Analysis |
| 27 | Incident Response (PICERL) | Incident Response | Protection & Defense | Defensive Cybersecurity; Digital Forensics |
| 28 | Digital Forensics Analysis | Digital Forensics | Investigation | Incident Response |
| 29 | Linux CLI Essentials for Pentesters | Vulnerability Analysis | Protection & Defense | Penetration Testing (foundational) |
| 30 | Suricata Log & Traffic Analysis | Defensive Cybersecurity | Protection & Defense | Incident Response; Digital Forensics |

## Work-role reference (verify IDs)

| Work role | NICE category | WRL ID |
|---|---|---|
| Vulnerability Analysis | Protection & Defense | PD-WRL-007 *(verify)* |
| Defensive Cybersecurity | Protection & Defense | PD-WRL-001 *(verify)* |
| Incident Response | Protection & Defense | PD-WRL-002 *(verify)* |
| Penetration Testing | Cyberspace Effects | CE-WRL-### *(verify)* |
| Exploitation Analysis | Cyberspace Effects | CE-WRL-### *(verify)* |
| Secure Software Development | Design & Development | DD-WRL-### *(verify)* |
| Digital Forensics | Investigation | IN-WRL-002 *(verify)* |

## Coverage summary (primary work role)

| Work role | Labs (primary) | Count |
|---|---|---|
| Penetration Testing | 02, 07, 08, 10, 12, 15, 16, 18, 21, 22, 24 | 11 |
| Vulnerability Analysis | 01, 03, 04, 05, 19, 20, 29 | 7 |
| Secure Software Development | 13, 14, 17, 26 | 4 |
| Exploitation Analysis | 09, 11, 25 | 3 |
| Defensive Cybersecurity | 06, 30 | 2 |
| Digital Forensics | 23, 28 | 2 |
| Incident Response | 27 | 1 |

**Coverage:** 7 work roles across 4 NICE categories (Protection & Defense, Cyberspace
Effects, Design & Development, Investigation) — spanning offensive, defensive, and
investigative sides of the framework. Related-role alignment additionally touches
Systems Security Analysis and Threat Analysis.

## Notes

- Primary role and NICE category now appear in each lab's Section 2 and match this table.
- The **WRL ID codes are best-effort and must be verified** against the current NICE
  Workforce Framework (NIST SP 800-181); category assignments are stable.
- "Related roles" is alignment guidance for coverage analysis (RQ-C1), not a second label
  inside the lab.
