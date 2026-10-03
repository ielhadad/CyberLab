# Deploying CyberLab to AWS EC2

This guide stands the segmented CyberLab up on a single Amazon EC2 instance — a
cloud version of the VirtualBox host, so students can reach it from anywhere without
a local VM. It is written for an instructor/operator.

The security model is the same as on VirtualBox: **nothing in the range is exposed to
the public internet.** The only inbound port on the instance is SSH, and you reach
the attacker's RDP desktop and Portainer through an **SSH tunnel**. Keep it that way —
this lab runs real offensive tooling.

> If you are on **AWS Academy Learner Lab**, read the note at the end first — a few
> steps differ (fixed credentials, limited instance types, session time limits).

---

## 0. What you'll need

- An AWS account with permission to launch EC2 instances (or an active AWS Academy
  Learner Lab session).
- An SSH key pair (you'll create one during launch).
- An SSH client: Terminal (macOS/Linux) or Windows Terminal / PuTTY.
- An RDP client for the GUI labs (Remote Desktop Connection, Windows App, or Remmina).

## 1. Choose the instance size

The attacker image (Kali + XFCE desktop + tools) is the heavy part, and some labs add
Metasploit or OpenVAS on demand.

| Use | Instance type | vCPU / RAM | Notes |
| --- | --- | --- | --- |
| Minimum | `t3.large` | 2 / 8 GB | Works; builds are slow and heavy labs feel tight |
| **Recommended** | `t3.xlarge` | 4 / 16 GB | Comfortable for one class running the same lab |
| Heavy / shared | `t3.2xlarge` | 8 / 32 GB | Multiple attackers or OpenVAS + Metasploit together |

- **Storage:** attach a **50 GB gp3** root EBS volume. The container images (Kali,
  Metasploitable, Juice Shop) are large.
- **Region:** pick the one closest to your students for better RDP latency.

## 2. Launch the instance (AWS Console)

1. **EC2 → Instances → Launch instances.**
2. **Name:** `cyberlab-host`.
3. **AMI:** **Ubuntu Server 24.04 LTS** (x86_64). *(Kali on AWS Marketplace also works
   and comes with host tooling, but Ubuntu is simpler and cheaper.)*
4. **Instance type:** `t3.xlarge` (see Step 1).
5. **Key pair:** *Create new key pair* → name it `cyberlab-key`, type **ED25519**,
   format `.pem` → **download and keep it safe** (you can't re-download it).
6. **Network settings → Edit → Security group:** create a new group `cyberlab-sg`
   with a **single** inbound rule:
   - Type **SSH**, Port **22**, Source **My IP** (not `0.0.0.0/0`).
   - **Remove every other inbound rule.** Do **not** open 3389, 80, 3000, 9443, etc.
7. **Configure storage:** set the root volume to **50 GiB, gp3**.
8. **Launch instance.**

> Prefer the CLI? See the `aws ec2 run-instances` snippet in the appendix below.

## 3. Connect over SSH

Find the instance's **Public IPv4** on the EC2 console, then:

```bash
chmod 400 cyberlab-key.pem
ssh -i cyberlab-key.pem ubuntu@<PUBLIC_IP>
```

(For a Kali AMI the user is `kali`, not `ubuntu`.)

## 4. Install Docker Engine + Compose

On the instance:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker            # apply the group now without logging out
docker run --rm hello-world   # sanity check
```

## 5. Clone and start the range

```bash
git clone https://github.com/ielhadad/cyberlab.git
cd cyberlab/range
docker compose build attacker      # first build is slow (desktop + tools)
docker compose up -d
docker ps                          # all containers Up?
```

You should see `attacker`, `router`, `juiceshop`, `dvwa`, `dns`, `metasploitable`,
`suricata`, and `portainer`.

> **Host networking:** the Suricata sensor uses host networking to sniff the lab
> bridges. That works on a normal Linux EC2 instance with no extra configuration.

## 6. Reach the attacker — over an SSH tunnel (not a public port)

The compose file binds RDP and Portainer to `127.0.0.1` on the instance, so they are
**not** reachable from the internet. Forward them to your own machine through SSH:

```bash
# Run on YOUR computer, not the instance:
ssh -i cyberlab-key.pem -N \
  -L 3389:127.0.0.1:3389 \
  -L 9443:127.0.0.1:9443 \
  ubuntu@<PUBLIC_IP>
```

Leave that running, then on your computer:

- **RDP desktop (GUI labs):** connect your RDP client to **`127.0.0.1:3389`**,
  log in **root / cyberrange**.
- **Portainer (IDS logs / container management):** browse to **`https://127.0.0.1:9443`**.
- **A terminal on the attacker:** in a second SSH session,
  `docker exec -it attacker bash`.

From here the range behaves exactly like the VirtualBox version — hand students the
[student-guide.md](student-guide.md).

## 7. Give students access

Pick one model:

- **Tunnel model (most secure):** each student SSHs in with the key and forwards 3389
  as in Step 6. Good for a small group; give them a read-only lab user.
- **Bastion / VPN model:** put the instance in a private subnet and front it with a
  VPN or AWS Systems Manager Session Manager; students connect through that.
- **Per-student instances:** for parallel work, launch one instance per student from
  the same AMI (snapshot a built one — Step 9), or run one `attacker` per student.

> Do **not** shortcut this by opening 3389 to `0.0.0.0/0`. Exposed RDP is scanned and
> brute-forced within minutes, and this host is full of attack tools.

## 8. Control cost

- **Stop** the instance when class isn't running (EC2 → Instance state → Stop). You pay
  only for EBS storage while stopped, not compute.
- Set a **Budget alert** (Billing → Budgets) so a left-on instance can't surprise you.
- `t3.xlarge` is billed per second while running — stopping overnight/weekends is the
  single biggest saving.

## 9. Snapshot a clean build (optional but recommended)

After `docker compose build && up` succeeds and you've verified the range:

1. EC2 → select the instance → **Actions → Image and templates → Create image.**
2. Launch future hosts (or per-student instances) from that AMI — they start with the
   images already built, skipping the slow first build.

## 10. Reset or tear down

```bash
# Reset the range (on the instance):
cd ~/cyberlab/range
docker compose down -v && docker compose up -d
```

To remove everything: **terminate** the instance (EC2 → Instance state → Terminate)
and delete the AMI/snapshots and the EBS volume if you made them, so you stop paying
for storage.

---

## Appendix A — Launch from the CLI

```bash
# Create a security group that allows SSH from your IP only
MYIP=$(curl -s https://checkip.amazonaws.com)
aws ec2 create-security-group --group-name cyberlab-sg \
  --description "CyberLab host - SSH only"
aws ec2 authorize-security-group-ingress --group-name cyberlab-sg \
  --protocol tcp --port 22 --cidr ${MYIP}/32

# Launch Ubuntu 24.04 (look up the current AMI ID for your region first)
aws ec2 run-instances \
  --image-id <UBUNTU_24_04_AMI_ID> \
  --instance-type t3.xlarge \
  --key-name cyberlab-key \
  --security-groups cyberlab-sg \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":50,"VolumeType":"gp3"}}]' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=cyberlab-host}]'
```

Find the current Ubuntu AMI for your region:

```bash
aws ssm get-parameter \
  --name /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id \
  --query 'Parameter.Value' --output text
```

## Appendix B — AWS Academy Learner Lab

If you're deploying inside the **AWS Academy Learner Lab** sandbox:

- **Credentials & key pair:** use the lab's provided access (the *vocareum* console) and
  the default key pair the lab offers; you may not be able to create IAM users or new
  key pairs. Download the Learner Lab key from the **AWS Details** panel.
- **Instance types:** the Learner Lab restricts sizes — `t3.large`/`t3.xlarge` are
  usually allowed; larger types may be blocked. Check the lab's allowed list.
- **Session limits:** the sandbox **stops your instances when the lab session ends**
  and has a total budget. Build the range, snapshot an AMI (Step 9) early, and expect
  to start/stop around session windows. Anything not on the EBS volume is lost when the
  sandbox resets.
- **Networking:** host networking and Docker work normally; the SSH-tunnel access model
  (Step 6) is the right one here too — do not open inbound ports in the sandbox's
  security group beyond SSH from your IP.

---

## Security checklist

- [ ] Security group inbound = **SSH (22) from my IP only** — nothing else.
- [ ] RDP and Portainer reached via **SSH tunnel**, never a public port.
- [ ] Instance **stopped** when not in use; **budget alert** set.
- [ ] Students understand: **targets stay inside the range** (see [DISCLAIMER.md](../DISCLAIMER.md)).
