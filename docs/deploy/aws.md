# CyberLab on AWS

Each student gets one EC2 instance in a standard AWS account, paid by the student or the course.
Back to [all environments](README.md).

| Who deploys | Students per deployment | Minimum size | Cost |
| --- | --- | --- | --- |
| Student or instructor | 1 | t3.large (8 GB); t3.xlarge (16 GB) recommended; 50 GB gp3 disk | Billed per second while running, plus storage |

## Where the steps are

- **Step-by-step:** [deploy-aws-ec2.md](../deploy-aws-ec2.md) and [student-aws-ec2-checklist.md](../student-aws-ec2-checklist.md).
- **Git clone option:** [Quick start](../../README.md#quick-start).
- **Bootstrap option:** `bootstrap-vps.sh` in [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md).
- **After deploying:** [post-deployment-verification.md](../post-deployment-verification.md).

## Before you start

- [ ] An AWS account with permission to launch EC2 instances.
- [ ] An [AWS Budget alert](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create.html) on the account.
- [ ] An SSH client and an RDP client.
- [ ] A region close to the students.

## Safety rules

1. Choose an x86 Ubuntu Server 24.04 instance; never an Arm (Graviton) type.
2. Allow only SSH (port 22) from your own IP in the security group.
3. Stop the instance after each session and terminate it at the end of the course.
4. Only work against the hosts inside the range.

## Feedback

Copy this table into an [issue](https://github.com/ielhadad/CyberLab/issues) or give it to your instructor.

| Question | Your answer |
| --- | --- |
| Your role (student or instructor) |  |
| Install method (git clone or bootstrap) |  |
| Instance type and region |  |
| Monthly cost observed (USD) |  |
| Date deployed |  |
| Time from start to working lab desktop (minutes) |  |
| Did the self-test pass on the first try? (yes / no / after retry) |  |
| Steps that were unclear or missing |  |
| Errors you hit and how you fixed them |  |
| Overall ease of deployment (1 = very hard, 5 = very easy) |  |
| Suggestions |  |
