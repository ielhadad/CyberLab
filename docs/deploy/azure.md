# CyberLab on Microsoft Azure

Each student gets one Azure virtual machine, paid by the course or by an eligible
student's Azure for Students credit. Back to [all environments](README.md).

| Who deploys | Students per deployment | Minimum size | Cost |
| --- | --- | --- | --- |
| Student or instructor | 1 | Standard_D2s_v5 (8 GB); D4s_v5 (16 GB) recommended; about 64 GB disk | Billed while running; Azure for Students gives eligible students $100 for 12 months |

## Where the steps are

This repository has no Azure-specific guide yet.

- **Create the VM:** Microsoft's [Linux VM quickstart](https://learn.microsoft.com/azure/virtual-machines/linux/quick-create-portal).
- **Install CyberLab:** the Cloud / VPS section of [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md), or the [Quick start](../../README.md#quick-start).
- **After deploying:** [post-deployment-verification.md](../post-deployment-verification.md).

## Before you start

- [ ] An Azure subscription. [Azure for Students](https://azure.microsoft.com/en-us/free/students) requires full-time enrollment, so many part-time students will need a course-paid subscription.
- [ ] Enough vCPU quota for the chosen VM size in your region.
- [ ] A cost alert on the subscription.
- [ ] An SSH client and an RDP client.

## Safety rules

1. Choose an x86 Ubuntu Server 24.04 image; never an Arm (Ampere) size.
2. In the network security group, allow only SSH (port 22) from your own IP.
3. **Stop and deallocate** the VM after each session; a VM shut down only from inside still incurs compute charges. Delete the resource group at the end of the course.
4. Only work against the hosts inside the range.

## Feedback

Copy this table into an [issue](https://github.com/ielhadad/CyberLab/issues) or give it to your instructor.

| Question | Your answer |
| --- | --- |
| Your role (student or instructor) |  |
| Subscription type (course-paid or Azure for Students) |  |
| Install method (git clone or bootstrap) |  |
| VM size and region |  |
| Monthly cost or credit used (USD) |  |
| Date deployed |  |
| Time from start to working lab desktop (minutes) |  |
| Did the self-test pass on the first try? (yes / no / after retry) |  |
| Steps that were unclear or missing |  |
| Errors you hit and how you fixed them |  |
| Overall ease of deployment (1 = very hard, 5 = very easy) |  |
| Suggestions |  |
