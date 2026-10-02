# NICE Framework Mapping

Every TCL lab is mapped to the [NICE Workforce Framework for Cybersecurity](https://niccs.cisa.gov/workforce-development/nice-framework)
(NIST SP 800-181 Rev. 1). The current lab set centers on the **Vulnerability
Analysis** work role (the daily work of finding, confirming, and prioritizing
weaknesses), while deliberately touching adjacent offensive and defensive tasks
so students see both sides.

> The table reflects the primary mapping authored into each lab's "NIST/NICE Role
> Alignment" section. Extend or re-map freely for your program — the labs are
> CC BY 4.0.

| # | Lab | Primary work role | Representative TKS emphasis |
|---|-----|-------------------|-----------------------------|
| 01 | DNS Footprinting | Vulnerability Analysis | Footprinting; interpreting DNS exposure |
| 02 | Packet Crafting with Scapy | Vulnerability Analysis | Protocol/packet fundamentals |
| 03 | Nmap / Zenmap / Masscan | Vulnerability Analysis | Host & service discovery |
| 04 | hping | Vulnerability Analysis | Crafted-probe reasoning; port state |
| 05 | OpenVAS | Vulnerability Analysis | Scanning; CVSS-based triage |
| 06 | Network Analysis | Vulnerability Analysis | Traffic capture & evidence extraction |
| 07 | Evading IDS | Vulnerability Analysis | Detection evasion & tuning (red/blue) |
| 08 | Password Cracking | Vulnerability Analysis | Credential-strength assessment |
| 09 | Metasploit & Armitage | Vulnerability Analysis | Exploitation to demonstrate impact |
| 10 | Web Pentesting | Vulnerability Analysis | Web app testing; proxy workflow |
| 11 | BeEF | Vulnerability Analysis | Client-side attack surface |
| 12 | ARP Spoofing & MITM | Vulnerability Analysis | On-path attacks; L2 controls |
| 13 | Buffer Overflows | Vulnerability Analysis | Root-cause analysis; secure coding |
| 14 | SQL Injection | Vulnerability Analysis | Injection analysis; parameterized fixes |
| 15 | Netcat Backdoor | Vulnerability Analysis | Exfiltration channels; egress control |
| 16 | VNC Backdoor | Vulnerability Analysis | Reverse C2; outbound monitoring |
| 17 | SSL Certificates | Vulnerability Analysis | TLS configuration assessment |
| 18 | Social Engineering (SET) | Vulnerability Analysis | Human-risk measurement; layered defense |

## Pedagogical framing
Each lab is written as a **problem-based** task (a client engagement) rather than
a script, and its Deliverable (do → capture → explain) completes an
**experiential-learning** cycle. The consistent NICE mapping lets you tie
classroom activity to employer-recognized competencies in a syllabus or program
assessment.

## Customizing the mapping
Lab mappings live in each `.docx` (Section 2). To align TCL to a specific course
or accreditation (e.g., CAE-CD knowledge units), edit that section and update this
table. Pull requests that broaden the mapping are welcome.
