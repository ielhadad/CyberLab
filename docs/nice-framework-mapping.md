# NICE Framework Mapping

All 30 CyberLab labs are mapped to the **Workforce Framework for Cybersecurity (NICE
Framework)**, NIST SP 800-181 Rev. 1, using **NICE Framework Components v2.2.0**
(April 28, 2025). Each lab has a **primary work role** and its **work role category**,
plus **related roles** it also exercises. Work role names and IDs were checked against
the official v2.2.0 components file published by NIST.

> **What changed from the earlier mapping.** NICE Framework Components v2.0.0 removed
> the Cyberspace Effects and Cyberspace Intelligence categories and their work roles
> (including Exploitation Analysis). "Penetration Testing" is not a NICE work role.
> The 14 labs previously mapped to those roles were remapped to current roles, mainly
> Vulnerability Analysis (PD-WRL-007), whose tasks include authorized penetration
> testing, and Software Security Assessment (DD-WRL-005) for web application testing.
> Digital Forensics (PD-WRL-002) is in Protection and Defense, and Incident Response
> is PD-WRL-003. Rows marked ✱ changed in this revision.

> This is a lab-level mapping. Task, Knowledge, and Skill (TKS) statement coverage is
> assessed separately in the research crosswalk.

## Lab-to-role mapping

| # | Lab | Primary work role | Work role category | Related roles |
|---|-----|-------------------|--------------------|---------------|
| 01 ✱ | DNS Reconnaissance & Zone-Transfer Testing | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Threat Analysis (PD-WRL-006); Network Operations (IO-WRL-004) |
| 02 ✱ | Packet Crafting with Scapy | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Defensive Cybersecurity (PD-WRL-001); Network Operations (IO-WRL-004) |
| 03 ✱ | Network Mapping (Nmap, Zenmap, Masscan) | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Network Operations (IO-WRL-004) |
| 04 ✱ | Packet Probing with hping3 | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Defensive Cybersecurity (PD-WRL-001); Network Operations (IO-WRL-004) |
| 05 | Vulnerability Scanning with OpenVAS | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Systems Security Analysis (IO-WRL-006) |
| 06 | Traffic Analysis (tcpdump, Wireshark) | Defensive Cybersecurity (PD-WRL-001) | Protection and Defense | Digital Forensics (PD-WRL-002) |
| 07 ✱ | Evading an IDS | Defensive Cybersecurity (PD-WRL-001) | Protection and Defense | Vulnerability Analysis (PD-WRL-007) |
| 08 ✱ | Password Cracking (John, Hashcat) | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Systems Security Analysis (IO-WRL-006) |
| 09 ✱ | Exploitation with Metasploit | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Systems Security Analysis (IO-WRL-006) |
| 10 ✱ | Web Application Testing (Nikto, Burp) | Software Security Assessment (DD-WRL-005) | Design and Development | Vulnerability Analysis (PD-WRL-007); Secure Software Development (DD-WRL-003) |
| 11 ✱ | Browser Exploitation with BeEF | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Software Security Assessment (DD-WRL-005) |
| 12 ✱ | ARP-Spoofing MITM | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Defensive Cybersecurity (PD-WRL-001); Network Operations (IO-WRL-004) |
| 13 ✱ | Buffer Overflow | Secure Software Development (DD-WRL-003) | Design and Development | Software Security Assessment (DD-WRL-005) |
| 14 ✱ | SQL Injection | Secure Software Development (DD-WRL-003) | Design and Development | Software Security Assessment (DD-WRL-005); Vulnerability Analysis (PD-WRL-007) |
| 15 ✱ | Netcat Backdoor | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Defensive Cybersecurity (PD-WRL-001); Incident Response (PD-WRL-003) |
| 16 ✱ | Reverse VNC Backdoor | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Defensive Cybersecurity (PD-WRL-001); Incident Response (PD-WRL-003) |
| 17 | SSL/TLS Certificates | Secure Software Development (DD-WRL-003) | Design and Development | Systems Security Analysis (IO-WRL-006) |
| 18 ✱ | Phishing with SET | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Threat Analysis (PD-WRL-006) |
| 19 ✱ | Scanning Methodology | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Network Operations (IO-WRL-004) |
| 20 ✱ | SMB Enumeration | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Systems Administration (IO-WRL-005) |
| 21 ✱ | Shell & Privilege Escalation | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Systems Security Analysis (IO-WRL-006); Systems Administration (IO-WRL-005) |
| 22 ✱ | Windows SAM Cracking | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Digital Forensics (PD-WRL-002) |
| 23 ✱ | Covering Tracks | Digital Forensics (PD-WRL-002) | Protection and Defense | Incident Response (PD-WRL-003); Digital Evidence Analysis (IN-WRL-002) |
| 24 ✱ | Web Hacking & Cookie Forgery | Software Security Assessment (DD-WRL-005) | Design and Development | Secure Software Development (DD-WRL-003); Vulnerability Analysis (PD-WRL-007) |
| 25 ✱ | Android Hacking | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Software Security Assessment (DD-WRL-005) |
| 26 | Cryptography (CLI) | Secure Software Development (DD-WRL-003) | Design and Development | Systems Security Analysis (IO-WRL-006) |
| 27 | Incident Response (PICERL) | Incident Response (PD-WRL-003) | Protection and Defense | Defensive Cybersecurity (PD-WRL-001); Digital Forensics (PD-WRL-002) |
| 28 ✱ | Digital Forensics Analysis | Digital Forensics (PD-WRL-002) | Protection and Defense | Incident Response (PD-WRL-003); Digital Evidence Analysis (IN-WRL-002) |
| 29 ✱ | Linux CLI Essentials for Pentesters | Vulnerability Analysis (PD-WRL-007) | Protection and Defense | Systems Administration (IO-WRL-005) |
| 30 | Suricata Log & Traffic Analysis | Defensive Cybersecurity (PD-WRL-001) | Protection and Defense | Incident Response (PD-WRL-003); Digital Forensics (PD-WRL-002) |

## Work roles used (v2.2.0)

| Work role | Work role category | ID |
|---|---|---|
| Secure Software Development | Design and Development | DD-WRL-003 |
| Software Security Assessment | Design and Development | DD-WRL-005 |
| Network Operations | Implementation and Operation | IO-WRL-004 |
| Systems Administration | Implementation and Operation | IO-WRL-005 |
| Systems Security Analysis | Implementation and Operation | IO-WRL-006 |
| Digital Evidence Analysis | Investigation | IN-WRL-002 |
| Defensive Cybersecurity | Protection and Defense | PD-WRL-001 |
| Digital Forensics | Protection and Defense | PD-WRL-002 |
| Incident Response | Protection and Defense | PD-WRL-003 |
| Threat Analysis | Protection and Defense | PD-WRL-006 |
| Vulnerability Analysis | Protection and Defense | PD-WRL-007 |

## Coverage summary (primary work role)

| Work role | ID | Labs (primary) | Count |
|---|---|---|---|
| Vulnerability Analysis | PD-WRL-007 | 01, 02, 03, 04, 05, 08, 09, 11, 12, 15, 16, 18, 19, 20, 21, 22, 25, 29 | 18 |
| Secure Software Development | DD-WRL-003 | 13, 14, 17, 26 | 4 |
| Defensive Cybersecurity | PD-WRL-001 | 06, 07, 30 | 3 |
| Software Security Assessment | DD-WRL-005 | 10, 24 | 2 |
| Digital Forensics | PD-WRL-002 | 23, 28 | 2 |
| Incident Response | PD-WRL-003 | 27 | 1 |

**Coverage:** 6 work roles as primary roles across 2 work role categories
(Protection and Defense: 24 labs, Design and Development: 6 labs). Related roles add
Threat Analysis, Systems Security Analysis, Network Operations, Systems Administration, Digital Evidence Analysis, bringing the total to 11 work roles in 4 of the 5 categories.
No lab maps to Oversight and Governance.

## Notes

- Each lab's Section 2 shows its primary role and category. Update the lab documents in
  the Instructor Resource Kit to match this table.
- "Related roles" is alignment guidance for coverage analysis (RQ3), not a second label
  inside the lab.
- Source: NIST, *NICE Framework Components v2.2.0* (JSON and XLSX), NICE Framework
  Resource Center, "NICE Framework: Current Versions."
