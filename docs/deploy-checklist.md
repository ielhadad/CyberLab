CyberLab — Student Deployment Checklist

A quick, tick-as-you-go checklist to get the lab running on your own computer. For detail on any step, see student-guide.md. Deploying to the cloud instead? Use deploy-aws-ec2.md.

Only attack the hosts inside this range — never anything outside it. See DISCLAIMER.md.

A. Install the virtual machine
 Install Oracle VirtualBox (virtualbox.org) on your laptop.
 Download an Ubuntu Server 24.04 LTS ISO (or Kali Linux).
 Create a new VM: 4+ CPUs, 8+ GB RAM (16 GB ideal), 60 GB disk.
 Attach the ISO and install the OS (create your login user when prompted).
 Network: add a Host-Only or Bridged adapter so you can reach the VM, and note the VM's IP (ip a).
 Take a VirtualBox snapshot of the clean install (easy rollback later).
B. Install Docker (inside the VM)
 sudo apt-get update
 Install Docker Engine + Compose plugin (see Step 4 of the deploy guide, or run the repo's install-docker.sh).
 sudo usermod -aG docker $USER then log out/in.
 Verify: docker run --rm hello-world
C. Get the lab and start it
 git clone https://github.com/ielhadad/CyberLab.git
 cd CyberLab/range
 docker compose build attacker (first build is slow — desktop + tools)
 docker compose up -d
 docker ps — confirm all containers are Up (attacker, router, juiceshop, dvwa, dns, metasploitable, suricata, portainer).
D. Connect to the attacker
 CLI labs: docker exec -it attacker bash
 GUI labs (RDP desktop): from your laptop, tunnel in — ssh -L 3389:127.0.0.1:3389 <user>@<vm-ip> — then open your Remote Desktop client to 127.0.0.1:3389, login root / cyberrange.
E. Verify you're ready
 whoami && hostname → root @ attacker
 nmap -sn 10.20.0.0/24 → the DMZ hosts answer
 curl -s http://10.20.0.11:3000 >/dev/null && echo OK → prints OK
 Remember: the LAN host 10.30.0.20 is not directly reachable — that's by design (reach it via the dvwa pivot; see the student guide).
F. Reset when needed
 cd range && docker compose down -v && docker compose up -d

Quick reference

text
GUI:    ssh -L 3389:127.0.0.1:3389 <user>@<vm-ip>   →  RDP 127.0.0.1:3389  (root/cyberrange)
CLI:    docker exec -it attacker bash
DMZ:    juiceshop 10.20.0.11:3000 · dvwa 10.20.0.12:80 · dns 10.20.0.53
LAN:    metasploitable 10.30.0.20  (via dvwa pivot)
Reset:  docker compose down -v && docker compose up -d
