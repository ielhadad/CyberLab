# Adding the CAI (Cybersecurity AI) container

CAI — [Cybersecurity AI](https://github.com/aliasrobotics/cai) by Alias Robotics —
is an agentic pentesting tool: you give it a goal in plain language and it drives
security tools (nmap, etc.), reasons over the output, and proposes next steps. In
Tiny CyberLab it becomes an optional **AI-assisted testing** station on the range,
sitting on the Internet segment alongside the attacker and reaching targets the
same way (through the firewall into the DMZ, and the LAN via the pivot).

CAI ships as a **pip package** (`cai-framework`), not an official Docker image, so
the "CAI container" is a small image we build around it. It calls an **external
LLM API**, so it needs an API key and uses API budget per run.

> Scope/safety: keep every target inside the range (the DMZ `10.20.0.0/24` and, via
> the pivot, the LAN `10.30.0.0/24`). CAI runs real tools — never point it at
> anything outside the lab. See [../DISCLAIMER.md](../DISCLAIMER.md).

---

## What gets added
| Item | Value |
| --- | --- |
| Container | `cai` on the Internet segment, IP `10.10.0.60` |
| Access | ttyd browser terminal `http://127.0.0.1:7682` · or `docker exec -it cai cai` |
| Needs | An LLM API key (OpenAI, Anthropic, or a local Ollama endpoint) + internet egress to that provider |

The files already exist in the repo under `range/cai/`:
- `range/cai/Dockerfile` — builds the CAI image
- `range/cai/cai.env.example` — template for your API key (copy to `cai.env`)
- a commented `cai:` service in `range/docker-compose.yml`

---

## Step 1 — Add your API key
```bash
cd range/cai
cp cai.env.example cai.env
nano cai.env          # set OPENAI_API_KEY (and/or ANTHROPIC_API_KEY) and CAI_MODEL
```
`cai.env` is already in `.gitignore` — **never commit your real key.**

CAI needs at least one provider key. Minimum working `cai.env`:
```
OPENAI_API_KEY="sk-...your key..."
CAI_MODEL="gpt-4o"
PROMPT_TOOLKIT_NO_CPR=1
```
(For Anthropic set `ANTHROPIC_API_KEY` and a matching `CAI_MODEL`; for a local,
no-cost model, point CAI at Ollama via the `OLLAMA` / `OPENAI_BASE_URL` settings —
see the [CAI install docs](https://aliasrobotics.github.io/cai/cai_installation/)
for current model names and variables.)

## Step 2 — Enable the service
Open `range/docker-compose.yml`, find the commented `# cai:` block near the
bottom, and **uncomment it** (remove the leading `#` on those lines).

## Step 3 — Build and start it
```bash
cd range
docker compose build cai
docker compose up -d cai
docker ps            # confirm 'cai' is running
```

## Step 4 — Use CAI
- **Browser:** open `http://127.0.0.1:7682` — you land straight in a CAI session.
- **From the host:** `docker exec -it cai cai`

Give it a scoped goal, e.g.:
> "Enumerate the web services in the DMZ (10.20.0.0/24) and suggest next steps.
> Stay inside the range — DMZ 10.20.0.0/24 and, only via the dvwa pivot, 10.30.0.20."

Watch it propose commands, run them, and interpret the output. Pause on a step and
ask whether it's right — that critique is the learning objective.

## Step 5 — Verify it can reach the range
```bash
docker exec -it cai nmap -sn 10.20.0.0/24     # should see the DMZ hosts (ICMP is allowed)
docker exec -it cai ping -c1 juiceshop        # names resolve via the cipher.lab DNS
```

---

## Notes
- **Cost:** every CAI action calls the LLM provider and spends budget. Set a spend
  limit on your API account before classroom use, or use a local Ollama model for
  zero per-token cost.
- **Egress:** the container must reach the provider's API over HTTPS. If your lab
  host has no internet, use a local Ollama model instead.
- **DMZ route:** like the attacker, the CAI container sits on the Internet segment,
  so to reach the DMZ it needs a route via the router. Add
  `ip route replace 10.20.0.0/24 via 10.10.0.254` at container start (it already has
  `NET_ADMIN`), or run it once with `docker exec cai ip route replace 10.20.0.0/24 via 10.10.0.254`.
- **This complements Lab 05 / the attacker:** CAI is an *AI-assisted* path to the
  same work students do by hand — ideal for a "direct and audit the AI" exercise,
  not a replacement for learning the tools.
- **Lighter alternative (no separate container):** CAI is just a pip package, so
  you can instead install it on the existing attacker image by adding
  `RUN pip install --break-system-packages cai-framework` to `range/attacker/Dockerfile`,
  rebuilding, and adding the same env vars. Use the dedicated container when you
  want CAI isolated with its own access and budget.
