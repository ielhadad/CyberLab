# Security Policy

## Scope
Tiny CyberLab (TCL) is a deliberately vulnerable **teaching range**. The
vulnerable targets and weak defaults (e.g. `root / cyberrange`) are intentional
and are **not** security issues — they exist for instruction and must only run
in an isolated lab (see [DISCLAIMER.md](DISCLAIMER.md)).

## What we do want to hear about
- Flaws in the range's **isolation** (e.g. a default that unexpectedly exposes
  the lab beyond the host).
- Supply-chain or build issues in the TCL-authored code (`range/attacker`,
  scripts, CI).
- Documentation that could lead a user to deploy TCL unsafely.

## Reporting
Please report privately rather than opening a public issue. Use GitHub's
**"Report a vulnerability"** (Security → Advisories) on this repository, or
email the maintainer at `<contact-email>`. We aim to acknowledge within a few
business days.

Do **not** include real credentials or data in a report.
