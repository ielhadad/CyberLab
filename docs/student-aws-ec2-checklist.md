# Student Deployment Checklist — CyberLab on AWS EC2 (Learner Lab)

Use this to stand up your **own** CyberLab on an AWS Academy Learner Lab EC2 instance
and connect to it. Tick each box in order. Budget ~30–40 minutes the first time (most
of it the one-time image build).

> **Scope & safety:** only attack the hosts *inside* your range. Never point these
> tools at AWS itself, other instances, or anything outside the lab. Keep the instance's
> firewall to **SSH-from-your-IP only**. See `DISCLAIMER.md`.

## A. Before you start
- [ ] You have an active **AWS Academy Learner Lab** seat.
- [ ] An **SSH client**: macOS/Linux Terminal, or Windows Terminal / PuTTY.
- [ ] An **RDP client**: Remote Desktop Connection (Windows), Windows App (macOS), or Remmina (Linux).
- [ ] The **`bootstrap-vps.sh`** script (from the course repo's `cyberlab-bootstrap/` folder).

## B. Start the Learner Lab
- [ ] Open the Learner Lab and click **Start Lab**; wait for the dot to turn **green**.
- [ ] Click **AWS** to open the console.
- [ ] Under **AWS Details**, download the SSH key **`labsuser.pem`** (you use the lab's key, not your own).

## C. Launch the EC2 instance
- [ ] EC2 → **Launch instances**. Name it `cyberlab`.
- [ ] AMI: **Ubuntu Server 24.04 LTS (x86_64)**.
- [ ] Instance type: **`t3.xlarge`** (or `t3.large` if that's blocked). *Never pick an Arm/`a1`/`t4g` type — the lab images are x86-only.*
- [ ] Key pair: choose the Learner Lab key (**`vockey`** / `labsuser.pem`).
- [ ] **Security group — one inbound rule only:** SSH (22), Source **My IP**. Remove all other inbound rules. Do **not** open 3389/80/3000.
- [ ] Storage: root volume **50 GiB, gp3**.
- [ ] **Launch**, then copy the instance's **Public IPv4** address.

## D. Connect over SSH
- [ ] `chmod 400 labsuser.pem`  (macOS/Linux)
- [ ] `ssh -i labsuser.pem ubuntu@<PUBLIC_IP>`

## E. Deploy the range
- [ ] Copy the script up: `scp -i labsuser.pem bootstrap-vps.sh ubuntu@<PUBLIC_IP>:~`
- [ ] Run it: `sudo bash bootstrap-vps.sh`
- [ ] Wait for the build (pulls ~3 GB + builds the desktop image). Watch: `tail -f /var/log/cyberlab-bootstrap.log`
- [ ] It finishes with access info and installs the `cyberlab` command.

## F. Connect to the attacker
- [ ] **GUI labs:** open the tunnel on your computer —
      `ssh -i labsuser.pem -L 3389:127.0.0.1:3389 ubuntu@<PUBLIC_IP>` — then RDP to **`127.0.0.1:3389`** (login **root / cyberrange**).
- [ ] **CLI labs:** on the instance, `docker exec -it attacker bash`.

## G. Verify it works
- [ ] `cyberlab verify` → should end with **"All checks passed."** (give it a minute and re-run if a check fails on first boot).
- [ ] `nmap -sn 10.20.0.0/24` → the DMZ hosts answer.
- [ ] Remember: `10.30.0.20` (LAN) is **not** directly reachable — reach it via the dvwa pivot.

## H. When you're done (every session)
- [ ] **Stop** the instance (EC2 → Instance state → **Stop**) to conserve the Learner Lab budget — you keep your work; you only pay compute while it runs.
- [ ] The Learner Lab also **stops instances when the session ends**; just Start Lab and start the instance again next time.
- [ ] Finished the course? **Terminate** the instance to free the disk.

---

**Quick reference**
```text
SSH         : ssh -i labsuser.pem ubuntu@<PUBLIC_IP>
Deploy      : sudo bash bootstrap-vps.sh
Tunnel+RDP  : ssh -i labsuser.pem -L 3389:127.0.0.1:3389 ubuntu@<PUBLIC_IP>  →  RDP 127.0.0.1:3389 (root/cyberrange)
CLI shell   : docker exec -it attacker bash
Verify      : cyberlab verify
DMZ targets : juiceshop 10.20.0.11:3000 · dvwa 10.20.0.12:80 · dns 10.20.0.53
LAN target  : metasploitable 10.30.0.20  (via the dvwa pivot)
```
