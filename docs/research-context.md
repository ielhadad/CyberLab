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

## Research questions (template)
- **RQ1.** [Does a single-host, Docker-based range deliver authentic hands-on
  learning comparable to heavier VM- or cloud-based ranges?]
- **RQ2.** [How does a project-based, NICE-aligned lab sequence affect students'
  self-efficacy and measured competence?]
- **RQ3.** [What are the cost, setup-time, and maintenance characteristics of TCL
  relative to alternative range models?]

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
plus 26 NICE-aligned labs.

## Contribution
1. An **open, reproducible, low-cost** range design that runs on a single host.
2. A **NICE-aligned, PBL-structured** lab set released under CC BY 4.0 for reuse
   and adaptation.
3. [An evaluation of its learning and cost-effectiveness outcomes — to be
   completed.]

## Evaluation plan (template)
- **Design:** [e.g., pre/post self-efficacy survey; practical skills assessment;
  comparison section or prior-cohort baseline.]
- **Participants:** [course(s), cohort size, consent.]
- **Measures:** [instrument(s), rubric tied to the NICE mapping, completion and
  time-on-task from lab deliverables.]
- **Analysis:** [methods.]
- **Ethics/IRB:** [status and approval number. Note: all lab activity is
  contained; the social-engineering lab uses fabricated credentials only.]

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
