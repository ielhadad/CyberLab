# Contributing to Tiny CyberLab (TCL)

Thanks for your interest! TCL is an open educational project and welcomes fixes,
new labs, and improvements from educators and practitioners.

## Ground rules
- Read [DISCLAIMER.md](DISCLAIMER.md) and the [Code of Conduct](CODE_OF_CONDUCT.md).
- Keep everything **lab-contained**: contributions must not weaken range
  isolation or encourage use outside an authorized lab.
- No real credentials, personal data, or real target systems in issues, PRs,
  labs, or screenshots.

## Ways to contribute
- **Bug / range issue** — something doesn't build or run. Open an issue using the
  template.
- **Lab issue or improvement** — a step is unclear, a tool/flag changed, or a
  target image drifted. Open a *Lab issue*.
- **New lab** — follow the existing 8-section structure (Introduction &
  Objectives, NICE Role Alignment, Topology, Learning Outcomes, Case Scenario,
  Lab Instructions, Deliverable, Additional Resources) and map it to a NICE work
  role.
- **Docs** — clarity fixes to the instructor/student guides are always welcome.

## Pull requests
1. Fork and create a branch (`fix/...`, `lab/...`, `docs/...`).
2. For range changes, verify `docker compose config` passes and the affected
   containers build and start.
3. Keep PRs focused; describe what changed and why.
4. Note which license applies to your change — code (MIT) or content (CC BY 4.0).

## Licensing of contributions
By submitting a contribution you agree it is licensed under this project's terms:
MIT for code/configuration, CC BY 4.0 for lab content and documentation.
