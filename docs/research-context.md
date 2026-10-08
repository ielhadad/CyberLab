# Research Context

This document frames Tiny CyberLab (TCL) as a research artifact. It is a
**scaffold** for the accompanying research proposal — fill the bracketed
placeholders with your specific questions, methods, and institutional details.

## Problem
Hands-on practice is widely regarded as essential to developing cybersecurity
competence, yet many higher-education programs cannot provide it at scale.
Commercial cyber ranges are costly, cloud-hosted ranges incur recurring expense,
and virtual-machine-per-student labs are heavy to build, distribute, and
maintain. The result is a gap between what employers expect (applied skills
mapped to recognized work roles) and what resource-constrained programs can
deliver — a facet of the broader **cybersecurity skills gap**.

## Research questions
The study evaluates the environment, not learners, in the context of Connecticut
Community Colleges.

- **RQ1. Technical and economic feasibility.** How do AWS, AWS Academy Learner Lab,
  Microsoft Azure, a commercial VPS, VirtualBox, and Proxmox compare in deployment
  efficiency, resource use, reliability, concurrent-session capacity, cost, and
  administrative effort when running CyberLab under standardized workloads
  representative of Connecticut Community College cybersecurity courses?
- **RQ2. Security and compliance.** To what extent does each deployment environment
  meet predefined requirements for laboratory isolation, access control, student
  data protection, and institutional authorization applicable to Connecticut
  Community Colleges?
- **RQ3. NICE Framework alignment.** To what extent do CyberLab's environment and lab
  activities support the Task, Knowledge, and Skill (TKS) statements of the NICE
  Framework work roles, and which work roles are fully supported, partially
  supported, or not supported?

## Approach
TCL operationalizes three established frameworks:

- **Problem-Based Learning (PBL)** — labs are realistic, ill-structured client
  tasks rather than step-by-step scripts.
- **Experiential learning** (Kolb's cycle) — each lab moves through concrete
  experience, reflective observation, abstract conceptualization, and active
  experimentation; the written deliverable is the reflection step.
- **NICE Workforce Framework for Cybersecurity** (NIST SP 800-181 Rev. 1) — every
  lab maps to a work role, tying activity to employer-recognized competencies.

The artifact itself is the intervention: a reproducible range (this repository)
plus 30 NICE-aligned labs.

## Contribution
1. An **open, reproducible, low-cost** range design that runs on a single host.
2. A **NICE-aligned, PBL-structured** lab set released under CC BY 4.0 for reuse
   and adaptation.
3. An evaluation of its feasibility, security and compliance, and NICE Framework
   alignment across six deployment environments.

## Evaluation plan
- **Design:** quantitative-dominant mixed methods; environment-only evaluation.
- **Participants:** none. Units of analysis are deployments, requirements, and
  NICE Framework TKS statements.
- **Environments:** AWS, AWS Academy Learner Lab, Microsoft Azure, a commercial VPS
  and VirtualBox (one dedicated student per deployment), and Proxmox (up to 10
  concurrent students per host).
- **Measures:** deployment time and success, functional self-test results, resource
  use and availability (Prometheus/node_exporter), cost per student and per course
  section, a predefined compliance checklist, and a crosswalk of lab activities to
  NICE Framework Components v2.2.0.
- **Analysis:** descriptive statistics; inter-rater reliability (Cohen's/Fleiss'
  kappa with bootstrap 95% CIs) for the crosswalk; qualitative field notes and
  reviewer comments to explain the quantitative results.
- **Ethics/IRB:** [status of the "not human subjects research" determination. Note:
  all lab activity is contained; the social-engineering lab uses fabricated
  credentials only.]

## Reproducibility
The range is defined entirely in `range/` (Compose file, attacker image, DNS
zone), so a reviewer can reproduce the environment with `docker compose up`. IPs,
images, and tool versions are documented in [architecture.md](architecture.md).

## Selected references (add your own)
- National Institute of Standards and Technology. *Workforce Framework for
  Cybersecurity (NICE Framework)*, NIST SP 800-181 Rev. 1.
- Kolb, D. A. *Experiential Learning: Experience as the Source of Learning and
  Development.*
- [Add PBL and cyber-range literature relevant to your proposal.]

> Replace this file's bracketed placeholders and reference list with the specifics
> of your proposal before submission.
