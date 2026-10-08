# CyberLab on VirtualBox

Each student runs their own CyberLab in a VirtualBox VM on their own x86 computer.
Back to [all environments](README.md).

| Who deploys | Students per deployment | Minimum size | Cost |
| --- | --- | --- | --- |
| Student, on their own computer | 1 | 8 GB RAM, 4 CPUs, 60 GB disk (16 GB RAM recommended) | Free; uses the student's hardware |

## Where the steps are

- **Step-by-step:** [student-Virtualbox-checklist.md](../student-Virtualbox-checklist.md).
- **Git clone option:** [Quick start](../../README.md#quick-start).
- **Bootstrap option:** `bootstrap-local.sh` in [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md).
- **After deploying:** [post-deployment-verification.md](../post-deployment-verification.md).

## Before you start

- [ ] A 64-bit x86 computer with virtualization enabled in BIOS/UEFI (not an Apple-silicon Mac).
- [ ] [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads) and the [Ubuntu Server 24.04 LTS](https://ubuntu.com/download/server) ISO.
- [ ] An SSH client and an RDP client.

## Safety rules

1. Prefer **NAT** networking with an SSH port forward (host `127.0.0.1:2222` to guest port 22), so the lab VM stays off your home or campus network.
2. Only work against the hosts inside the range.
3. Take a snapshot of the clean install so you can roll back in seconds.

## Feedback

Copy this table into an [issue](https://github.com/ielhadad/CyberLab/issues) or give it to your instructor.

| Question | Your answer |
| --- | --- |
| Your role (student or instructor) |  |
| Install method (git clone or bootstrap) |  |
| Your computer's RAM and CPU |  |
| Date deployed |  |
| Time from start to working lab desktop (minutes) |  |
| Did the self-test pass on the first try? (yes / no / after retry) |  |
| Steps that were unclear or missing |  |
| Errors you hit and how you fixed them |  |
| Overall ease of deployment (1 = very hard, 5 = very easy) |  |
| Suggestions |  |
