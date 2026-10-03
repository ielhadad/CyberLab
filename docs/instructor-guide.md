# Instructor Guide

How to stand up Tiny CyberLab (TCL) and run it with a class.

## 1. Prepare the host
1. Create a **Kali or Ubuntu Server** VM in Oracle VirtualBox (4+ vCPU and 8+ GB
   RAM recommended; the attacker desktop image is large). **Linux host networking
   is required** for the Suricata sensor.
2. Give the VM a **host-only or bridged** adapter if you want to tunnel RDP to it.
   The lab ports are published on `127.0.0.1` only; students connect from the host
   itself or over a VPN/SSH tunnel — never expose RDP to the public internet.
3. Install Docker Engine and the Compose plugin.

## 2. Build and start the range
```bash
git clone https://github.com/ielhadad/cyberlab.git
cd cyberlab/range
docker compose build attacker     # first build is slow (desktop + tools)
docker compose up -d
docker ps
docker network inspect br-dmz
docker network inspect br-lan
```
Optional: pre-pull target images (`docker compose pull`) before class.

## 3. Verify
- `docker ps` shows all containers up (attacker, router, juiceshop, dvwa, dns,
  metasploitable, suricata, portainer).
- From the host, RDP to `127.0.0.1:3389` (root / cyberrange) → XFCE desktop; or
  `docker exec -it attacker bash`.
- From the attacker, `nmap -sn 10.20.0.0/24` lists the DMZ hosts; the LAN
  (`10.30.0.20`) is **not** directly reachable — that is by design (pivot labs).
- Lab 1 check: `dig @10.20.0.53 cipher.lab` resolves; the AXFR **succeeds** from
  the attacker because the router NATs its source into the DMZ (that bypass is the
  lesson — see the answer key).

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
- **IDS (Lab 7)** reads Suricata events via `docker logs suricata`, Portainer's log
  viewer, or `docker exec -it suricata tail -f /var/log/suricata/eve.json`. Suricata
  sniffs `br-inet` and `br-lan`, so attacker→DMZ scans are visible on `br-inet`.
- **Pivot labs (5, 9, 15, 16, 20, 21)** target `metasploitable` on the LAN, reached
  through the dual-homed `dvwa`. Each lab's *Reaching the target* box explains the
  pivot and offers a DMZ/offline fallback where a full pivot is out of scope.
- If a GUI package name has drifted in the Kali repo, drop it from the last
  `RUN` in `range/attacker/Dockerfile` and rebuild.

## 6. Assessment
Each lab ends with a **Deliverable** (screenshots + a short written report) and a
terminal activity log step. The brief-report requirement is deliberate: it is the
reflection stage of the experiential cycle. Pair the labs with the NICE mapping
([nice-framework-mapping.md](nice-framework-mapping.md)) when writing rubrics.
