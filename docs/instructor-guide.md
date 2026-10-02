# Instructor Guide

How to stand up Tiny CyberLab (TCL) and run it with a class.

## 1. Prepare the host
1. Create an **Ubuntu Server** VM in Oracle VirtualBox (4+ vCPU and 8+ GB RAM
   recommended; the attacker desktop image is large).
2. Give the VM a **host-only or bridged** network adapter and note its IP — this
   is `<lab-host-ip>` throughout the labs. If you use a NAT adapter only, add
   port-forwards for 3389, 7681, and 2222.
3. Install Docker Engine and the Compose plugin.

## 2. Build and start the range
```bash
git clone https://github.com/ielhadad/tiny-cyberlab.git
cd tiny-cyberlab/range
docker compose build attacker     # first build is slow (desktop + tools)
docker compose up -d
docker ps
docker network inspect cyberlab_net
```
Optional: pre-pull target images (`docker compose pull`) before class.

## 3. Verify
- `docker ps` shows all containers up.
- From the host, RDP to `<lab-host-ip>:3389` (root / cyberrange) → XFCE desktop.
- From the attacker, `nmap -sn 10.30.0.0/24` lists the other containers.
- Lab 1 check: `dig @10.30.0.53 cipher.lab` resolves; AXFR from the attacker is
  refused but succeeds from `victim`.

## 4. Running it with students
- **Shared vs. per-student:** one range comfortably supports a small group doing
  the same lab. For larger or parallel work, run one range per student (a VM
  clone, or one `attacker` per student on the same network) and have each student
  take their own snapshot.
- **Reset between sessions:**
  ```bash
  cd range
  docker compose down -v && docker compose up -d
  ```
- **Snapshots:** take a VirtualBox snapshot of the host VM after a clean build so
  you can roll back a broken session in seconds.

## 5. Tool notes
- **GUI labs** (Zenmap, Armitage, Burp, Wireshark, Ettercap) are done over RDP on
  the attacker desktop. CLI equivalents exist for all of them if you prefer
  headless.
- **OpenVAS (Lab 5)** is large; install it on demand inside the attacker:
  `apt-get install -y gvm && gvm-setup && gvm-start`.
- **IDS (Lab 7)** reads Suricata events via EveBox or `docker logs ids`.
- If a GUI package name has drifted in the Kali repo, drop it from the last
  `RUN` in `range/attacker/Dockerfile` and rebuild.

## 6. Assessment
Each lab ends with a **Deliverable** (screenshots + a short written report) and a
terminal activity log step. The brief-report requirement is deliberate: it is the
reflection stage of the experiential cycle. Pair the labs with the NICE mapping
([nice-framework-mapping.md](nice-framework-mapping.md)) when writing rubrics.
