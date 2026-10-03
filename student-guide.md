# Student Step-by-Step Guide — Using the CyberLab

This is the full walkthrough for working in Tiny CyberLab (TCL). If you just need
the short version, see [student-quickstart.md](student-quickstart.md). Read this
once before your first lab; after that, each lab document tells you exactly what to
do.

---

## Before you start — the one rule that matters

> **Only scan, probe, and attack the hosts inside this range.** Never point any tool
> in this lab at a real website, a classmate's machine, the campus network, or
> anything outside the range. Everything here is contained on purpose — keep it that
> way. See [DISCLAIMER.md](../DISCLAIMER.md).

## What you are working in

The CyberLab is **not** one flat network — it is built like a small company network,
split into three zones behind a firewall:

| Zone | What's in it | Can you reach it from the attacker? |
| --- | --- | --- |
| **Internet** `10.10.0.0/24` | your `attacker` box + the `router` | You *are* here |
| **DMZ** `10.20.0.0/24` | the web apps (`juiceshop`, `dvwa`) + `dns` | Yes — web ports, DNS, and ping only |
| **LAN** `10.30.0.0/24` | the internal `metasploitable` server | No — only by **pivoting** (see Step 6) |

Learning to work *through* the firewall and *pivot* to the internal host is part of
the point. Don't be surprised when the LAN host doesn't answer a direct scan — that
is the firewall doing its job.

---

## Step 1 — Connect to the attacker workstation

Everything you do starts from the **attacker** box. Pick the method your lab needs.

**A. Graphical desktop (use this for GUI labs — Zenmap, Burp, Wireshark, Ettercap, Armitage)**

1. Open a Remote Desktop client on the lab host:
   - **Windows:** *Remote Desktop Connection* (`mstsc`)
   - **macOS:** *Windows App* (formerly Microsoft Remote Desktop)
   - **Linux:** *Remmina*
2. Connect to **`127.0.0.1:3389`**.
3. Log in with **username `root`**, **password `cyberrange`**.
4. You land on the Kali XFCE desktop. Open a terminal from the taskbar.

**B. Command-line only (use this for CLI labs)**

On the lab host, run:

```bash
docker exec -it attacker bash
```

You get a `root@attacker` shell immediately — no password needed.

> Working remotely? Your instructor will tell you how to tunnel to RDP over the
> VPN/SSH. RDP is **not** published to the public internet.

## Step 2 — Confirm you're in and can reach the DMZ

Run these from the attacker to prove your connection and your route into the DMZ:

```bash
whoami && hostname          # should say: root @ attacker
ip route                    # you should see a route to 10.20.0.0/24 via 10.10.0.254
nmap -sn 10.20.0.0/24       # the DMZ hosts answer (ICMP is allowed through the firewall)
curl -s http://10.20.0.11:3000 >/dev/null && echo "juiceshop reachable"
```

If `nmap -sn` lists the DMZ hosts and the `curl` line prints "juiceshop reachable,"
you're ready. If not, jump to **Troubleshooting**.

## Step 3 — Know your targets

Hosts answer by **name** (via the lab DNS) *and* by **IP**:

| Zone | Name | IP | What it is |
| --- | --- | --- | --- |
| DMZ | `juiceshop` | 10.20.0.11 | Modern web app (port 3000) |
| DMZ | `dvwa` | 10.20.0.12 | Classic vulnerable web app (port 80) — also the LAN pivot |
| DMZ | `dns` | 10.20.0.53 | DNS server for `cipher.lab` |
| Internet/DMZ | `router` | 10.10.0.254 / 10.20.0.254 | The firewall |
| LAN | `metasploitable` | 10.30.0.20 | Vulnerable Linux server (reached **via pivot**) |

Check the live layout any time with `nmap -sn 10.20.0.0/24` or, on the host,
`docker ps`.

## Step 4 — Open your lab and pick a track

Each lab is a Word document (`labs/TCL_NN_...docx`). Open the one your instructor
assigned. Every lab offers the **same exercise at three levels of support** — do the
one your instructor set, or climb the ladder yourself:

| Track | What you get | Use it to… |
| --- | --- | --- |
| **6A — Guided** | Exact commands + an "Expected" check after each step, then a short Practice task | Learn the moves |
| **6B — Unguided** | The objectives only, with a Hints box | Practice with less help |
| **6C — Capture the Flag** | A scenario with point-scored flags and **no instructions** | Prove you can do it alone |

## Step 5 — Work through the lab

Every lab has the same eight sections. Here's how to use them:

1. **Introduction & Objectives** — what you'll do and the tools involved. Read it first.
2. **NICE Role Alignment** — the real-world job skill this maps to (for your résumé/portfolio).
3. **Network Topology, IPs & Credentials** — your targets and logins for *this* lab,
   plus a **"Reaching the target in this lab"** box. **Always read that box** — it
   tells you whether the target is in the DMZ (reach it directly) or on the LAN
   (you'll need the pivot in Step 6).
4. **Learning Outcomes** — what you should be able to do by the end.
5. **Case Scenario** — the story framing (you're an analyst at Summit Cyber Group
   assessing the client, Cipher Logistics). It sets the goal.
6. **Lab Activities** — the three tracks above. **Do the work here.**
7. **Deliverable** — what to hand in (Step 8).
8. **Additional Resources** — references and walkthrough videos if you get stuck.

Tips while you work:
- If a tool isn't installed on the attacker, install it on the spot, e.g.
  `apt-get update && apt-get install -y <tool>` (the attacker has internet; the DMZ/LAN do not).
- Keep notes as you go — you'll need them for the report.

## Step 6 — Reaching the LAN (the pivot)

Some labs (Metasploit, SMB enumeration, backdoors, privilege escalation) target
**metasploitable** on the internal LAN. The firewall won't route you there directly,
so you go *through* a host that touches both zones. `dvwa` is **dual-homed**
(`10.20.0.12` in the DMZ, `10.30.0.12` on the LAN) and is deliberately vulnerable —
its **Command Injection** page gives you code execution on it, which is your foothold.

The pattern:

1. **Get execution on `dvwa`** — use its Command Injection page (set DVWA security to
   *low*), which runs your commands on a host that sits on the LAN.
2. **Route your tools through `dvwa`** — set up a SOCKS proxy / port-forward from that
   foothold, then run tools with `proxychains`.
3. **Attack `10.30.0.20`** as though you were local to the LAN.

If a full pivot is beyond your assignment, treat reaching the LAN host as the
**bonus** — complete the lab's technique against a DMZ host or with the offline data
the lab gives you. The lab's *"Reaching the target"* box tells you which applies.

## Step 7 — Capture your evidence

As you complete each step, take screenshots that show your **entire terminal or
browser window** — including the prompt and the command you typed. Do **not** crop
those out; the command and its context are part of the proof.

Every lab ends with a **Terminal Activity Log** step. Run it on the attacker and
screenshot the final output:

```bash
history 10 > labNN.txt      # NN = your lab number, e.g. lab09.txt
last -n 10 >> labNN.txt
cat labNN.txt
```

## Step 8 — Write the deliverable

Submit **one PDF or document** containing, in order:

1. The screenshots the lab's Deliverable section asks for (full windows, uncropped).
2. The Terminal Activity Log screenshot from Step 7.
3. A **brief report** — a short written explanation of *what you did and why it
   worked*. This is not a caption under each picture; it's the "so what." It's also
   the reflection part of the learning, so it counts.

Submit it the way your instructor specified (LMS upload, email, etc.).

## Step 9 — Reset if something breaks

If a target goes down, you make a mess, or you just want a clean slate, tell your
instructor — the whole range resets with one command on the host:

```bash
cd range
docker compose down -v && docker compose up -d
```

---

## Troubleshooting

| Symptom | Likely cause → fix |
| --- | --- |
| Can't RDP to `127.0.0.1:3389` | Attacker still building/starting. On the host: `docker ps` — wait until `attacker` is up, or `docker compose up -d attacker`. |
| `nmap -sn 10.20.0.0/24` finds nothing | Missing route. On the attacker: `ip route replace 10.20.0.0/24 via 10.10.0.254`. |
| A DMZ host shows very few open ports | Expected — the firewall forwards only web ports (80/3000), DNS (53), and ICMP into the DMZ. |
| Can't reach `10.30.0.20` (metasploitable) directly | Also expected — the LAN has no route in. Use the pivot (Step 6). |
| A command says "command not found" | Install it on the attacker: `apt-get update && apt-get install -y <tool>`. |
| Names like `juiceshop` don't resolve | Query the lab DNS: `dig @10.20.0.53 juiceshop.cipher.lab`, or just use the IP. |
| Reading the IDS alerts (Lab 7) | On the host: `docker logs -f suricata`, or open Portainer at `https://127.0.0.1:9443`. |

## Quick reference

```text
Connect (GUI):   RDP 127.0.0.1:3389   root / cyberrange
Connect (CLI):   docker exec -it attacker bash
DMZ web:         http://10.20.0.11:3000  (juiceshop)   http://10.20.0.12/  (dvwa)
DMZ DNS:         dig @10.20.0.53 <name>.cipher.lab
LAN target:      10.30.0.20  (metasploitable — via dvwa pivot)
Reset range:     cd range && docker compose down -v && docker compose up -d
```
