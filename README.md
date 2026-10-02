<!-- Replace ielhadad and <contact-email> before publishing. -->
# Tiny CyberLab (TCL)

**A small, reproducible, Docker-based cyber range for hands-on cybersecurity
education — designed to close the cybersecurity skills gap in higher education
through project-based and experiential learning.**

![Tiny CyberLab topology](docs/topology.png)

Tiny CyberLab (TCL) runs an entire attack-and-defend teaching range as a handful
of Docker containers on a **single Ubuntu Server host** (an Oracle VirtualBox VM).
One attacker workstation and a set of deliberately vulnerable targets share an
isolated bridge network, so a student needs only a browser or an RDP client to
complete a full penetration-testing curriculum — no per-student VMs, no cloud
bill, no specialized hardware.

TCL ships with **26 ready-to-run labs** mapped to the
[NICE Workforce Framework for Cybersecurity](https://niccs.cisa.gov/workforce-development/nice-framework)
(NIST SP 800-181 Rev. 1), spanning reconnaissance, scanning, vulnerability
analysis, exploitation, post-exploitation, and defensive analysis.

> ⚠️ **For authorized, contained lab use only.** TCL installs real offensive
> security tooling. Read [DISCLAIMER.md](DISCLAIMER.md) before you deploy it.

---

## Why TCL exists (research context)

Cybersecurity programs struggle to give students authentic, hands-on practice:
commercial ranges are expensive, cloud ranges incur recurring cost, and
VM-per-student labs are heavy to build and maintain. TCL is the artifact of a
research effort asking a simple question:

> *Can a cyber range small and cheap enough to run on one laptop still deliver
> the authentic, project-based experience that builds workforce-ready skills?*

TCL is built around three learning frameworks:

- **Problem-Based Learning (PBL)** — each lab is an ill-structured, realistic
  task (a client engagement), not a copy-paste script.
- **Experiential learning (Kolb's cycle)** — students do, observe, conceptualize,
  and experiment, then write up findings.
- **NICE Framework alignment** — every lab maps to a recognized work role so
  classroom activity ties directly to employer-recognized competencies.

See [`docs/research-context.md`](docs/research-context.md) for the problem
statement, approach, contribution, and evaluation plan.

---

## What's in the box

| Component | Description |
| --- | --- |
| `range/` | The reference topology: `docker-compose.yml`, the attacker image, and a BIND zone. |
| `labs/` | 26 instructor-authored lab exercises (.docx), NICE-mapped, with a deliverable and rubric cues. |
| `docs/` | Topology diagram, architecture, instructor guide, student quick-start, NICE mapping, research context. |

### The range

| Host | IP (reference) | Role |
| --- | --- | --- |
| `attacker` | 10.30.0.10 | Kali toolset + XFCE desktop over RDP (every lab) |
| `dns` | 10.30.0.53 | BIND, authoritative for `cipher.lab` (Lab 1) |
| `juice-shop` | 10.30.0.20 | OWASP Juice Shop (web labs) |
| `dvwa` | 10.30.0.21 | DVWA (web / SQLi labs) |
| `victim` | 10.30.0.30 | Metasploitable 2 (exploitation, MITM, backdoors) |
| `ids` | 10.30.0.40 | Suricata sensor (IDS-evasion lab) |
| `caldera` | 10.30.0.50 | MITRE Caldera (adversary emulation) |

All containers share the `cyberlab_net` bridge (`10.30.0.0/24`) and resolve each
other by name. The labs use a fictional engagement — **Summit Cyber Group**
(the consultancy the student works for) assessing **Cipher Logistics** (the
client) — purely as narrative framing.

---

## Quick start

> Prerequisites: an Ubuntu Server VM in VirtualBox with Docker Engine + the
> Compose plugin. See [`docs/instructor-guide.md`](docs/instructor-guide.md).

```bash
git clone https://github.com/ielhadad/tiny-cyberlab.git
cd tiny-cyberlab/range
docker compose build attacker      # large image (desktop + tools); first build is slow
docker compose up -d
docker ps                          # confirm names/IPs
```

**Access the attacker workstation** (from the Ubuntu host):

| Method | Address | Use |
| --- | --- | --- |
| RDP desktop | `<lab-host-ip>:3389` (root / cyberrange) | GUI labs (Zenmap, Armitage, Burp, Wireshark, Ettercap) |
| Browser terminal (ttyd) | `http://<lab-host-ip>:7681` | CLI labs |
| SSH | `ssh root@<lab-host-ip> -p 2222` | CLI labs |

See [`docs/student-quickstart.md`](docs/student-quickstart.md) for the
student-facing version.

---

## The 18 labs

See [`labs/README.md`](labs/README.md) for the full index. In short: DNS
footprinting, packet crafting, Nmap/Masscan recon, hping, OpenVAS, network
analysis, IDS evasion, password cracking, Metasploit, web pentesting, BeEF,
ARP/MITM, buffer overflows, SQL injection, Netcat and VNC backdoors, TLS
certificates, and social engineering with SET.

---

## Using TCL in your course

TCL is released so other educators and researchers can run, adapt, and extend
it. You are encouraged to fork it, swap the fictional client, re-map labs to
your syllabus, and contribute improvements back. See
[CONTRIBUTING.md](CONTRIBUTING.md).

---

## Citing this work

If you use TCL in teaching or research, please cite it — see
[CITATION.cff](CITATION.cff) or:

> Elhadad, S. (2026). *Tiny CyberLab (TCL): A reproducible Docker-based cyber
> range for project-based cybersecurity education.* Capital Community College.
> https://github.com/ielhadad/tiny-cyberlab

---

## Publications & related work

Selected publications by the author related to cybersecurity education and cyber
ranges. <!-- TODO: replace the placeholders below with your real titles, venues, years, and links. -->

- [Publication title 1] — _[Venue], [Year]._ [link](#)
- [Publication title 2] — _[Venue], [Year]._ [link](#)
- [Publication title 3] — _[Venue], [Year]._ [link](#)

<!-- Add or remove entries as needed. See CITATION.cff for machine-readable references. -->

---

## License

- **Code and configuration** (`range/`, scripts, CI): [MIT](LICENSE).
- **Lab content and documentation** (`labs/`, `docs/`): [CC BY 4.0](LICENSE-docs).

This dual-license lets anyone reuse the infrastructure freely while requiring
attribution for the teaching materials. Prefer copyleft? Swap `LICENSE` for
GPL-3.0 and this section accordingly.

## Acknowledgments

Built on open-source projects including Kali Linux, OWASP Juice Shop, DVWA,
Metasploitable, Suricata, MITRE Caldera, and the many tools the labs exercise.
Lab design aligns with the NIST/NICE Workforce Framework for Cybersecurity.
