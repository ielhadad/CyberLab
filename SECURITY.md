# Security

## This project contains vulnerable software on purpose

CyberLab deploys deliberately insecure applications (DVWA, OWASP Juice Shop, Metasploitable 2) for education. By design:

- The DMZ and LAN Docker networks are `internal` and have no route to the internet.
- Management interfaces (Portainer on 9443, the SOCKS proxy on 1080) bind to `127.0.0.1` only.
- The EC2 bootstrap enables a host firewall that allows SSH only.

Keep it that way:

- **Do not** publish lab ports on `0.0.0.0` or open extra ports in a cloud security group.
- **Do not** run CyberLab on a production server, a shared campus host, or a machine holding sensitive data.
- Use the attacker tools **only against the lab targets**. Scanning or attacking systems you do not own or have written permission to test may be illegal. See the [Acceptable Use Policy](ACCEPTABLE_USE.md).
- In the cloud, restrict SSH to your own IP address and stop instances when not in use.

## Reporting a vulnerability

If you find a flaw in CyberLab itself that exposes a host beyond the intended lab (for example, a service reachable from outside, or a segmentation bypass that was not meant as an exercise), please report it privately using GitHub's **Security → Report a vulnerability** on this repository rather than opening a public issue.

Vulnerabilities in the intentionally vulnerable target applications are expected and are not security issues for this project.
