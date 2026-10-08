# Deploying CyberLab

CyberLab runs as eight Docker containers on one x86 Linux host (Ubuntu Server 24.04).
Every environment below uses the same range from this repository, installed by the
same bootstrap scripts. Five environments give each student a dedicated host;
Proxmox lets an instructor run isolated copies for up to 10 students at once.

This folder holds one page per environment. Each page links to the step-by-step
instructions that already live in this repository, so there is only one copy of
every procedure.

## Choose your environment

| Environment | Who deploys | Students per deployment | Minimum size | Cost model | Page |
| --- | --- | --- | --- | --- | --- |
| VirtualBox | Student, on their own computer | 1 | 8 GB RAM, 4 CPUs, 60 GB disk | Free (student hardware) | [virtualbox.md](virtualbox.md) |
| AWS (standard account) | Student or instructor | 1 | t3.large (8 GB); t3.xlarge (16 GB) recommended | Pay per second while running | [aws.md](aws.md) |
| AWS Academy Learner Lab | Student, inside an instructor-created lab | 1 | t3.large (8 GB), usually the largest size allowed | $100 credit per student | [aws-academy.md](aws-academy.md) |
| Microsoft Azure | Student or instructor | 1 | Standard_D2s_v5 (8 GB); D4s_v5 (16 GB) recommended | Pay per second; Azure for Students credit for eligible students | [azure.md](azure.md) |
| Commercial VPS | Student or instructor | 1 | 8 GB x86 plan; 16 GB recommended | Fixed monthly or hourly | [vps.md](vps.md) |
| Proxmox | Instructor, on college hardware | Up to 10 (one isolated pod each) | About 8 GB RAM per pod plus host overhead | Hardware bought once | [proxmox.md](proxmox.md) |

Apple-silicon Macs (M1–M4) cannot run the x86 lab images well. Students with those
Macs should use a cloud option.

## Two ways to install

- **Git clone:** see [Quick start](../../README.md#quick-start) in the main README.
- **Bootstrap script:** run `bootstrap-local.sh` (VirtualBox, Proxmox) or
  `bootstrap-vps.sh` (AWS, Azure, VPS) on the host, or paste the VPS script as
  cloud-init. See [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md).
  The bootstrap also installs the `cyberlab` management command.

Both build the same range.

## Before you start (all environments)

**Everyone needs:**

- [ ] An SSH client (built into Windows 10/11, macOS and Linux terminals).
- [ ] An RDP client: Remote Desktop Connection or Windows App (Windows/macOS), or Remmina (Linux).
- [ ] About 45 minutes for the first build, which downloads about 3 GB of images.

**Instructors also need:**

- [ ] The cloud accounts, AWS Academy class, or Proxmox hardware for the option chosen.
- [ ] A billing or budget alert on every paid cloud account.
- [ ] Students' signed acknowledgement of [ACCEPTABLE_USE.md](../../ACCEPTABLE_USE.md) and [DISCLAIMER.md](../../DISCLAIMER.md).

## Safety rules (all environments)

1. Only work against the hosts **inside** the range. Never point lab tools at home,
   campus or any outside network.
2. Open **only SSH (port 22)**, and only from your own IP address, in any cloud
   firewall. Never open RDP (3389) or Portainer (9443) to the internet.
3. Reach the lab desktop through an **SSH tunnel**: the range binds RDP and Portainer
   to `127.0.0.1` on the host by design.
4. Use an x86 host only (no Arm, Graviton, Ampere or Hetzner CAX types).
5. **Stop or deallocate** cloud hosts when not in use, and **terminate** them at the
   end of the course.

## After deploying

Run the checks in [post-deployment-verification.md](../post-deployment-verification.md)
after every deployment. Connection steps for students are in
[student-guide.md](../student-guide.md) and [student-quickstart.md](../student-quickstart.md).

## Feedback

Each environment page has its own feedback form. Fill it in after you deploy, or
[open an issue](https://github.com/ielhadad/CyberLab/issues) describing what was
unclear or what went wrong.
