# Student Quick-Start

Everything you do in Tiny CyberLab happens from the **attacker** workstation,
against the lab's target containers. You only need a remote-desktop client or a
terminal on the lab host.

The range is **segmented into three zones behind a firewall**, just like a real
network:

- **Internet `10.10.0.0/24`** — the `attacker` (10.10.0.10) and the `router`.
- **DMZ `10.20.0.0/24`** — the web apps and DNS. The firewall lets the attacker
  reach these on web ports (80, 3000), DNS (53), and ICMP only.
- **LAN `10.30.0.0/24`** — the internal `metasploitable` host. There is **no
  direct route** from the attacker; you reach it by **pivoting** through `dvwa`.

> Only scan and attack the targets inside the range. Never point these tools at
> anything outside the lab. See [DISCLAIMER.md](../DISCLAIMER.md).

## 1. Connect to the attacker

- **Graphical desktop (for GUI labs — Zenmap, Armitage, Burp, Wireshark, Ettercap):**
  open a Remote Desktop client and connect to **`127.0.0.1:3389`** on the lab host
  (Windows: *Remote Desktop Connection*; macOS: *Windows App*; Linux: *Remmina*).
  Log in **root / cyberrange** → Kali XFCE desktop.
- **Terminal (for CLI labs):** on the lab host run **`docker exec -it attacker bash`**.

(Working remotely? Your instructor will tell you how to tunnel to RDP — it is not
exposed to the public internet.)

## 2. Check you're in and can reach the DMZ
```bash
whoami && hostname                 # root @ attacker
ip route                           # note the route to 10.20.0.0/24 via the router
nmap -sn 10.20.0.0/24              # the DMZ hosts answer (ICMP is allowed)
curl -s http://10.20.0.11:3000 >/dev/null && echo "juiceshop reachable"
```

## 3. Find your targets
Hosts resolve by name (via the DNS server) **and** by IP:

| Zone | Name | IP | What it is |
| --- | --- | --- | --- |
| DMZ | juiceshop | 10.20.0.11 | web app (port 3000) |
| DMZ | dvwa | 10.20.0.12 | web app (port 80) — also the LAN pivot |
| DMZ | dns | 10.20.0.53 | DNS for `cipher.lab` |
| Internet/DMZ | router | 10.10.0.254 / 10.20.0.254 | firewall |
| LAN | metasploitable | 10.30.0.20 | vulnerable Linux (**via pivot**) |

(Confirm with `nmap -sn 10.20.0.0/24`, or `docker ps` on the host, if addresses differ.)

## 4. Reaching the LAN — a short pivoting primer
Some labs (Metasploit, SMB enumeration, backdoors, privilege escalation) target
**metasploitable** on the internal LAN. The firewall will not route you there, so
you go *through* a DMZ host that is connected to both zones — `dvwa` is **dual-homed**
(`10.20.0.12` in the DMZ, `10.30.0.12` on the LAN). `dvwa` is deliberately
vulnerable (its **Command Injection** page gives you code execution on it), which
is your intended foothold.

The usual pattern:

1. **Get execution on dvwa** via its Command Injection page (DVWA security = low),
   or use it as your pivot node.
2. **Route traffic through dvwa** to the LAN — for example with a SOCKS proxy /
   port-forward from your foothold, then run tools through `proxychains`.
3. **Attack `10.30.0.20`** as if you were local to the LAN.

If a full pivot is beyond your assignment, treat reaching the LAN host as the
**bonus objective** and complete the lab's technique against a DMZ host or with the
offline data the lab provides. Each lab's *Reaching the target* box tells you which
applies.

## 5. Do the lab and submit
Each lab offers three tracks — **Guided** (follow along), **Unguided** (objectives
+ hints), and **Capture-the-Flag** (no instructions) — and ends with a
**Deliverable**: screenshots showing your full terminal/browser window, plus a
short written report explaining what you did and why it worked. Finish with the
terminal-activity-log step in the lab.

## Stuck?
Re-read the lab's *Hints* and *Additional Resources* before asking. If the range
itself seems broken (a target is down, you can't connect), tell your instructor —
it resets with one command.
