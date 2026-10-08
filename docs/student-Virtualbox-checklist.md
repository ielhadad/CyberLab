# Student Deployment Checklist — CyberLab on VirtualBox (local)

Use this to run your **own** CyberLab inside a virtual machine on your computer. Tick
each box in order. Budget ~45 minutes the first time (OS install + the one-time image
build).

> **Scope & safety:** only attack the hosts *inside* your range. Never point these
> tools at your home network, the campus network, or anything outside the VM. See
> `DISCLAIMER.md`.

> **Hardware note:** this needs a **64-bit x86** computer with virtualization enabled
> in BIOS/UEFI. Apple-silicon Macs (M1–M4) can't run the x86 lab images well — use the
> **AWS EC2** checklist instead.

## A. Before you start
- [ ] **8 GB RAM minimum / 16 GB recommended**, and ~60 GB free disk.
- [ ] Install **Oracle VirtualBox** (virtualbox.org).
- [ ] Download an **Ubuntu Server 24.04 LTS** ISO.
- [ ] The **`bootstrap-local.sh`** script (from the course repo's `cyberlab-bootstrap/` folder).
- [ ] An **RDP client** (Remote Desktop Connection / Windows App / Remmina).

## B. Create the VM
- [ ] VirtualBox → **New**. Name `cyberlab-host`, Type **Linux**, Version **Ubuntu (64-bit)**.
- [ ] Memory: **8192 MB+** (16384 if you can). CPUs: **4+**.
- [ ] Create a virtual hard disk: **60 GB**.
- [ ] **Settings → Network → Adapter 1**: leave on **NAT** (gives the VM internet access).
- [ ] **Settings → Network → Adapter 2**: enable it and set to **Host-Only Adapter**, so you can reach the VM from your computer. Do **not** use **Bridged** — it puts the lab VM on your home or campus network.
- [ ] **Settings → Storage**: attach the Ubuntu ISO to the optical drive.

## C. Install Ubuntu Server
- [ ] Start the VM and run the installer.
- [ ] Create your login username and password.
- [ ] When offered, **enable "Install OpenSSH server"** (you need SSH to deploy).
- [ ] Finish, reboot, and log in.
- [ ] Note the VM's IP: run **`ip a`** and copy the Host-Only address (usually `192.168.56.x`; not `10.0.2.15`, which is the NAT adapter) → this is `<vm-ip>`.

## D. Snapshot the clean install
- [ ] Power off the VM, then in VirtualBox take a **Snapshot** named "clean install" (lets you roll back in seconds).
- [ ] Power the VM back on.

## E. Deploy the range
- [ ] From your computer, copy the script to the VM: `scp bootstrap-local.sh <user>@<vm-ip>:~`
- [ ] SSH in: `ssh <user>@<vm-ip>`
- [ ] Run it: `sudo bash bootstrap-local.sh`
- [ ] Wait for the build (pulls ~3 GB + builds the desktop image). Watch: `tail -f /var/log/cyberlab-bootstrap.log`
- [ ] It finishes with access info and installs the `cyberlab` command.

## F. Connect to the attacker
- [ ] **GUI labs:** open a tunnel from your computer —
      `ssh -L 3389:127.0.0.1:3389 <user>@<vm-ip>` — then RDP to **`127.0.0.1:3389`** (login **root / cyberrange**).
- [ ] **CLI labs:** in your SSH session, `docker exec -it attacker bash`.

## G. Verify it works
- [ ] `cyberlab verify` → should end with **"All checks passed."** (give it a minute and re-run if a check fails on first boot).
- [ ] `nmap -sn 10.20.0.0/24` → the DMZ hosts answer.
- [ ] Remember: `10.30.0.20` (LAN) is **not** directly reachable — reach it via the dvwa pivot.

## H. When you're done
- [ ] Stop the range to free resources: `cd range && docker compose down` (or just shut down the VM).
- [ ] Something broke? Reset the range: `cd range && docker compose down -v && docker compose up -d`, or roll back to your **snapshot**.

---

**Quick reference**
```text
VM IP       : ip a   (inside the VM)
Deploy      : scp bootstrap-local.sh <user>@<vm-ip>:~   then   sudo bash bootstrap-local.sh
Tunnel+RDP  : ssh -L 3389:127.0.0.1:3389 <user>@<vm-ip>  →  RDP 127.0.0.1:3389 (root/cyberrange)
CLI shell   : docker exec -it attacker bash
Verify      : cyberlab verify
DMZ targets : juiceshop 10.20.0.11:3000 · dvwa 10.20.0.12:80 · dns 10.20.0.53
LAN target  : metasploitable 10.30.0.20  (via the dvwa pivot)
Reset       : cd range && docker compose down -v && docker compose up -d
```
