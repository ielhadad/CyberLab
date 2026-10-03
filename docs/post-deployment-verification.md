# Post-Deployment Test & Verify

Run this right after deploying (VirtualBox or AWS) to confirm the range is healthy and
**correctly segmented** before you start a lab. Run everything from the attacker unless
noted: `docker exec -it attacker bash`.

## 1. One-command self-test
```bash
cyberlab verify
```
It should finish with **"All checks passed."** It checks segmentation, DNS, the pivot,
the IDS and the services in one pass. If a check or two fail on first boot, wait ~1
minute (Suricata is loading rules) and run it again. If something stays red, use the
manual matrix below to isolate it.

## 2. Containers are up
```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```
- [ ] All eight are **Up**: `attacker`, `router`, `juiceshop`, `dvwa`, `dns`, `metasploitable`, `suricata`, `portainer`.

## 3. Manual verification matrix
Run each; confirm the result matches **Expected**. "Allowed" and "blocked" results are
both *correct* — they prove the firewall is doing its job.

| # | What it proves | Command (from the attacker unless noted) | Expected |
|---|---|---|---|
| 1 | Attacker identity | `whoami && hostname` | `root` @ `attacker` |
| 2 | Route to the DMZ exists | `ip route` | a route to `10.20.0.0/24 via 10.10.0.254` |
| 3 | DMZ web reachable (Juice Shop) | `curl -s -o /dev/null -w "%{http_code}\n" http://10.20.0.11:3000` | `200` |
| 4 | DMZ web reachable (DVWA) | `curl -s -o /dev/null -w "%{http_code}\n" http://10.20.0.12` | `200` or `302` |
| 5 | DNS resolves `cipher.lab` | `dig +short @10.20.0.53 juiceshop.cipher.lab` | `10.20.0.11` |
| 6 | **Firewall blocks non-web DMZ ports** | `nc -z -w3 10.20.0.12 3306; echo $?` | non-zero (DVWA's MySQL is **not** reachable) |
| 7 | **LAN not directly reachable** | `ping -c1 -W2 10.30.0.20; echo $?` | non-zero (blocked by design) |
| 8 | Zone transfer bypass (Lab 1) | `dig @10.20.0.53 cipher.lab AXFR \| grep -c metasploitable` | `1` (AXFR succeeds via NAT — the finding) |
| 9 | **Pivot works** (run on dvwa) | `docker exec dvwa bash -c 'timeout 3 bash -c "</dev/tcp/10.30.0.20/21" && echo open'` | `open` (dvwa can reach the LAN host) |
| 10 | IDS is watching | `docker logs --tail 5 suricata` | Suricata running, no fatal errors |
| 11 | IDS raises an alert | scan, then check: `nmap -sS 10.20.0.12 >/dev/null; sleep 5; docker exec suricata grep -ic scan /var/log/suricata/fast.log` | `1` or more |

## 4. GUI access works (if you'll run GUI labs)
- [ ] Open the RDP tunnel (`ssh -L 3389:127.0.0.1:3389 <user>@<host>`), connect an RDP client to `127.0.0.1:3389`, log in **root / cyberrange**, and confirm the XFCE desktop loads.
- [ ] In the desktop, open Firefox and load `http://10.20.0.11:3000` (Juice Shop) to confirm the desktop has network.

## 5. Security sanity check (nothing exposed)
Run **on the host** (not in a container):
```bash
ss -ltn | grep -E ':3389|:9443|:1080'
```
- [ ] Every match is bound to **`127.0.0.1`** only — never `0.0.0.0`. On a cloud host, confirm the security group allows **only SSH (22)** from your IP.

## 6. Sign-off
- [ ] `cyberlab verify` passed, **or** every row of the matrix matched Expected.
- [ ] GUI desktop reachable over the tunnel (if needed).
- [ ] No lab port is exposed beyond `127.0.0.1` / the SSH-only security group.

If a test fails, see the **Troubleshooting** section of your deployment guide
(`docs/student-guide.md` or the deployment checklist). Most first-boot failures are
timing — re-run `cyberlab verify` after a minute before digging deeper.
