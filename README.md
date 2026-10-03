# CyberLab

A segmented **Internet / DMZ / LAN** cyber range for hands-on, project-based
security courses. It runs the same Docker-based lab — intentionally vulnerable
web apps, a pivot host, a Kali attack box, Suricata IDS and Nuclei scanning —
either on a student laptop (VirtualBox) or in the cloud (AWS Academy Learner Lab).

> ⚠️ **Safety first.** This lab contains **intentionally vulnerable software**.
> Run it only on machines and accounts you own or are authorized to use. Never
> expose its targets to the internet or a production network, and attack only
> the targets inside your own lab. See [ACCEPTABLE_USE.md](ACCEPTABLE_USE.md).

## Purpose and research context

CyberLab is the practical platform for a line of research on **closing the
cybersecurity skills gap in higher education through hands-on, project-based
learning**. The premise is that learners build durable security skills by doing
real work in a realistic environment — running reconnaissance, exploiting and
then hardening live systems, and watching an IDS react — rather than by reading
about it. This range gives every student that environment at near-zero cost, on
a laptop or in the cloud, so hands-on practice is not gated by hardware or budget.

The design draws on established learning models:

- **Project-based and problem-based learning (PBL):** each lab is a scenario with
  a goal (breach a target, then defend it), not a disconnected exercise.
- **Experiential learning:** students act, observe the result (scan findings, IDS
  alerts), and reflect — a full do-observe-reflect cycle inside one environment.
- **NICE Framework alignment:** lab activities map to NICE work roles and tasks —
  vulnerability analysis, incident response, systems hardening — so learning
  connects to recognized workforce competencies.

The lab is used both as a **teaching tool** and as an **instrument for research**
into how project-based cyber ranges affect skill acquisition, engagement and
readiness. *(Instructors: replace this paragraph with your specific proposal
title, research questions, and any IRB / consent details before publishing.)*

## What's inside

- A firewalled DMZ (Juice Shop, DVWA) reachable from a Kali attacker box.
- An internal LAN host (Metasploitable 2) reachable only by pivoting through DVWA.
- Suricata network IDS on the perimeter and LAN bridges.
- Portainer for a Docker GUI, and Nuclei for template-based vulnerability scanning.
- One command — `cyberlab` — to bring it up, verify, scan, monitor and reset.

## Choose your option

| You have | Use | Cost |
| --- | --- | --- |
| A laptop with 8 GB+ RAM (x86) | **VirtualBox** | Free |
| A course enrolled in AWS Academy | **AWS Academy Learner Lab** | Free (class credits) |

### VirtualBox (local)

```bash
git clone https://github.com/<owner>/cyberlab.git   # or download the release zip
cd cyberlab
sha256sum -c SHA256SUMS          # every line should say OK
sudo bash bootstrap-local.sh
```

### AWS Academy Learner Lab

Launch a **t3.large**, **Ubuntu Server 24.04** instance with the **vockey** key
pair and the **LabInstanceProfile** IAM profile, and paste the contents of
`bootstrap-cloud.sh` into **Advanced details → User data**. Then SSH in and run
`cyberlab verify`. The full click-path is in the deployment guide under `docs/`.

## Using the lab

```bash
sudo cyberlab up        # start the lab
sudo cyberlab verify    # self-test (segmentation, services, IDS, Nuclei)
sudo cyberlab scan http://10.20.0.12    # Nuclei vulnerability scan
sudo cyberlab alerts    # live Suricata IDS alerts
sudo cyberlab down      # stop the lab
```

See `docs/CyberLab-Quick-Reference.md` for the full command and task reference,
and `docs/Deployment-Guide.md` for every hosting option and troubleshooting.

## Repository layout

```
bootstrap-local.sh    VirtualBox / local build
bootstrap-cloud.sh    EC2 / Lightsail user-data build
lab/                  docker-compose.yml — the lab (source of truth)
scripts/              cyberlab — the management command (source of truth)
build/                build-bootstrap.py — regenerates the bootstrap files
aws/  virtualbox/     per-option launch/tuning helpers
docs/                 deployment guide, student quickstart, quick reference
```

`lab/` and `scripts/` are the source of truth; the two `bootstrap-*.sh` files
are generated from them by `build/build-bootstrap.py`.

## License

Scripts and code: [MIT](LICENSE). Documentation: [CC BY 4.0](LICENSE-docs).

## Maintainer

Saaid Elhadad — *(add your institution and a public contact address here)*
