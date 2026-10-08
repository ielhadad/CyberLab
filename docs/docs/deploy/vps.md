# CyberLab on a Commercial VPS

Each student gets one virtual private server from a commercial provider, such as
Hetzner, DigitalOcean or Lightsail. Back to [all environments](README.md).

| Who deploys | Students per deployment | Minimum size | Cost |
| --- | --- | --- | --- |
| Student or instructor | 1 | 8 GB x86 plan (e.g., Hetzner cx33); 16 GB (cx43) recommended; 50–60 GB disk | Fixed monthly or hourly price |

## Where the steps are

- **Step-by-step:** the Cloud / VPS and Hetzner Cloud sections of [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md). `bootstrap-vps.sh` also adds swap, an SSH-only firewall, fail2ban and automatic security updates.
- **Git clone option:** [Quick start](../../README.md#quick-start).
- **After deploying:** [post-deployment-verification.md](../post-deployment-verification.md).

## Before you start

- [ ] An account with a VPS provider and a payment method or course account.
- [ ] An SSH key pair, an SSH client and an RDP client.
- [ ] Confirmation that the provider's acceptable-use policy permits a contained security-training lab.

## Safety rules

1. Choose an x86 plan; never an Arm plan (such as Hetzner CAX).
2. In the provider's firewall, allow only SSH (port 22) from your own IP.
3. Delete the server at the end of the course; many providers bill while a server exists, even when powered off.
4. Only work against the hosts inside the range.

## Feedback

Copy this table into an [issue](https://github.com/ielhadad/CyberLab/issues) or give it to your instructor.

| Question | Your answer |
| --- | --- |
| Your role (student or instructor) |  |
| Provider and plan |  |
| Install method (bootstrap, Hetzner launch, or git clone) |  |
| Monthly cost (USD) |  |
| Date deployed |  |
| Time from start to working lab desktop (minutes) |  |
| Did the self-test pass on the first try? (yes / no / after retry) |  |
| Steps that were unclear or missing |  |
| Errors you hit and how you fixed them |  |
| Overall ease of deployment (1 = very hard, 5 = very easy) |  |
| Suggestions |  |
