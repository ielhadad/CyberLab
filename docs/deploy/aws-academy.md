# CyberLab on AWS Academy Learner Lab

Each student runs CyberLab on one instance inside an AWS Academy Learner Lab that the
instructor creates, paid from the student's per-student credit.
Back to [all environments](README.md).

| Who deploys | Students per deployment | Minimum size | Cost |
| --- | --- | --- | --- |
| Student, inside the instructor's Learner Lab | 1 | t3.large (8 GB), usually the largest size allowed | $100 credit per student; no charge to the college |

## Where the steps are

- **Step-by-step:** Appendix B of [deploy-aws-ec2.md](../deploy-aws-ec2.md), together with [student-aws-ec2-checklist.md](../student-aws-ec2-checklist.md).
- **Git clone option:** [Quick start](../../README.md#quick-start).
- **Bootstrap option:** `bootstrap-vps.sh` in [cyberlab-bootstrap/README.md](../../cyberlab-bootstrap/README.md).
- **After deploying:** [post-deployment-verification.md](../post-deployment-verification.md).

## Before you start

- [ ] **Instructor:** college membership in AWS Academy, a completed educator orientation, and a Learner Lab course with students enrolled.
- [ ] **Student:** access to the Learner Lab and its AWS Details panel, which holds the key pair.
- [ ] An SSH client and an RDP client.

## Know the limits

- Instance sizes are restricted; t3.large (8 GB) matches CyberLab's minimum with no headroom.
- Only the regions the Learner Lab allows can be used.
- Instances stop when a lab session ends; start them again at the next session.
- Account permissions are restricted; use the lab's provided role and key pair.
- Spending comes from the student's credit, so stop the instance whenever you are not working.

Confirm these limits in your current Learner Lab; they change over time.

## Safety rules

1. Choose an x86 Ubuntu Server 24.04 instance.
2. Allow only SSH (port 22) from your own IP.
3. Only work against the hosts inside the range.

## Feedback

Copy this table into an [issue](https://github.com/ielhadad/CyberLab/issues) or give it to your instructor.

| Question | Your answer |
| --- | --- |
| Your role (student or instructor) |  |
| Install method (git clone or bootstrap) |  |
| Instance type and region |  |
| Credit used by the end of the course (USD) |  |
| Problems caused by session stops or account limits |  |
| Date deployed |  |
| Time from start to working lab desktop (minutes) |  |
| Did the self-test pass on the first try? (yes / no / after retry) |  |
| Steps that were unclear or missing |  |
| Errors you hit and how you fixed them |  |
| Overall ease of deployment (1 = very hard, 5 = very easy) |  |
| Suggestions |  |
