# Acceptable Use Policy

CyberLab contains **intentionally vulnerable software** for the purpose of
learning offensive and defensive security techniques. By downloading, deploying
or using this lab, you agree to the following.

## You must

1. **Attack only the targets inside your own lab** — the `10.10.0.0/24`,
   `10.20.0.0/24` and `10.30.0.0/24` networks running on your own host or your
   own cloud instance.
2. **Run the lab in isolation.** Never expose its target services to the public
   internet, a campus network, or any production system. The only ports the lab
   binds are `127.0.0.1:9443` (Portainer) and `127.0.0.1:1080` (SOCKS proxy).
3. **Use only machines and accounts you own or are authorized to use.**
4. **Protect your credentials.** Never commit SSH keys, `.pem` files, AWS
   credentials, or generated password files to any repository.

## You must not

1. Scan, attack, or attempt to access **any system outside your own lab** —
   including other students' labs, the range or campus infrastructure, cloud
   provider infrastructure, or any third party.
2. Use the tools or techniques learned here against systems without **explicit
   written authorization**.
3. Leave a vulnerable lab instance running unattended or reachable from an
   untrusted network.

## Notes

- Activity in institution-hosted deployments **may be logged** for security and
  academic-integrity purposes.
- Unauthorized scanning or attacks may violate your institution's policies and
  the law (for example the U.S. Computer Fraud and Abuse Act and equivalents).
- If you find a security issue in this kit itself, please open an issue rather
  than exploiting it.

Violations may result in loss of lab access and referral under your
institution's academic-integrity and acceptable-use policies.
