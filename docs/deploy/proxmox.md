# CyberLab on Proxmox

The instructor builds a Proxmox host or cluster on college hardware and gives each of
up to 10 concurrent students an isolated CyberLab pod cloned from one template.
Back to [all environments](README.md).

| Who deploys | Students per deployment | Sizing | Cost |
| --- | --- | --- | --- |
| Instructor, on college hardware | Up to 10 concurrent, one isolated pod each | About 8 GB RAM per pod, so roughly 80 GB for 10 pods plus host overhead | Hardware bought once, plus power and maintenance |

## Where the steps are

- **Range inside the template:** `bootstrap-local.sh` in [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md), or the [Quick start](../../README.md#quick-start).
- **Cluster, isolated networking, per-student pods and student access:** the instructor's Proxmox build guide (add it to this folder as `proxmox-build.md` when published).
- **Proxmox reference:** [Proxmox VE documentation](https://pve.proxmox.com/pve-docs/).
- **After deploying:** [post-deployment-verification.md](../post-deployment-verification.md), run in each pod.

## Before you start

- [ ] **Instructor:** x86 servers with enough RAM for the pods planned, approval from college IT, and a network segment isolated from the campus network.
- [ ] **Instructor:** a plan for how students reach their pod (an access gateway).
- [ ] **Student:** the access details the instructor provides, plus an RDP client or web browser, depending on the gateway.

## Safety rules

1. Keep every pod isolated from the campus network and from other students' pods.
2. Expose only the access gateway; never the pods themselves.
3. Reset or re-clone pods between classes so each student starts clean.
4. Only work against the hosts inside your own pod.

## Feedback

Copy this table into an [issue](https://github.com/ielhadad/CyberLab/issues) or give it to your instructor.

| Question | Your answer |
| --- | --- |
| Your role (student or instructor) |  |
| Hardware used (nodes, RAM) |  |
| Number of concurrent students served |  |
| Date deployed |  |
| Time from start to working lab desktop (minutes) |  |
| Did the self-test pass on the first try? (yes / no / after retry) |  |
| Steps that were unclear or missing |  |
| Errors you hit and how you fixed them |  |
| Overall ease of deployment (1 = very hard, 5 = very easy) |  |
| Suggestions |  |
