# Contributing to CyberLab

Bug reports and fixes from students and other instructors are welcome.

## Reporting a problem

Open an issue and include:

- **Which option** you used (VirtualBox or AWS Academy Learner Lab).
- **Your host OS** and, for VirtualBox, whether the host is x86 or ARM
  (Apple Silicon).
- **The exact command** you ran and **the output** (paste it, or attach the
  relevant lines from `/var/log/cyberlab-bootstrap.log`).
- What you expected to happen, and what happened instead.

Please do **not** paste any secrets — SSH keys, AWS credentials, or passwords —
into an issue.

## Making a change

The source of truth is `lab/docker-compose.yml` and `scripts/cyberlab`. The two
`bootstrap-*.sh` files are **generated**, so:

1. Edit `lab/` and/or `scripts/`.
2. Regenerate the bootstraps: `python3 build/build-bootstrap.py`.
3. Refresh checksums: `find . -type f -not -path './.git/*' -not -name SHA256SUMS -print0 | xargs -0 sha256sum > SHA256SUMS`.
4. Test the full path once on the option you changed and confirm `cyberlab verify` passes.
5. Open a pull request describing what you changed and how you tested it.

## Scope

This is a teaching lab. Changes that keep it simple, safe and easy for students
to run are preferred over ones that add complexity.
