# Student Quick-Start

Everything you do in Tiny CyberLab happens on the **attacker** workstation,
against the lab's target containers. You only need a browser or a remote-desktop
client. Your instructor will give you the lab host's address — shown below as
`<lab-host-ip>`.

> Only scan and attack the targets inside the range (`10.30.0.0/24`). Never point
> these tools at anything outside the lab. See [DISCLAIMER.md](../DISCLAIMER.md).

## 1. Connect to the attacker

Pick the one your lab needs:

- **Graphical desktop (for GUI labs — Zenmap, Armitage, Burp, Wireshark, Ettercap):**
  open a Remote Desktop client and connect to **`<lab-host-ip>:3389`**
  (Windows: *Remote Desktop Connection*; macOS: *Windows App*; Linux: *Remmina*).
  Log in **root / cyberrange** → Kali XFCE desktop.
- **Browser terminal:** go to **`http://<lab-host-ip>:7681`**.
- **SSH:** `ssh root@<lab-host-ip> -p 2222` (password `cyberrange`).

## 2. Check you're in and can reach a target
```bash
whoami && hostname
nmap -sn 10.30.0.0/24       # list the lab's containers
ping -c 3 juice-shop        # targets resolve by name
```

## 3. Find your targets
Containers resolve by name **and** by IP:

| Name | IP | What it is |
| --- | --- | --- |
| juice-shop | 10.30.0.20 | web app (port 3000) |
| dvwa | 10.30.0.21 | web app (port 80) |
| victim | 10.30.0.30 | vulnerable Linux |
| dns | 10.30.0.53 | DNS for cipher.lab |

(Confirm with `nmap -sn 10.30.0.0/24` or ask your instructor if addresses differ.)

## 4. Do the lab and submit
Each lab lists numbered steps and ends with a **Deliverable**: screenshots that
show your full terminal/browser window, plus a short written report explaining
what you did and why it worked. Finish with the terminal-activity-log step in the
lab.

## Stuck?
Re-read the lab's *Stuck?* nudges and *Additional Resources* before asking. If the
range itself seems broken (a target is down, you can't connect), tell your
instructor — it resets with one command.
