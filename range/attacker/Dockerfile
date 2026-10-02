# Attacker container for Tiny CyberLab (TCL) — labs 01-18.
# Full Kali toolset + XFCE desktop reachable over RDP, so the GUI labs
# (Zenmap, Armitage, Burp Suite, Ettercap, Wireshark) work without a separate VM.
# This image is LARGE (desktop + tools). First build will take a while.
FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive

# --- CLI toolset (most labs) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
      nmap masscan hping3 python3-scapy tcpdump \
      nikto whatweb gobuster dirb sqlmap cewl crunch wordlists \
      metasploit-framework beef-xss set netcat-traditional \
      john hashcat openssl apache2 build-essential gcc \
      default-mysql-server default-mysql-client \
      openssh-server ttyd curl iputils-ping dnsutils net-tools vim nano \
  && rm -rf /var/lib/apt/lists/*

# --- XFCE desktop + XRDP (graphical access) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
      kali-desktop-xfce xorg xrdp xorgxrdp dbus-x11 \
  && rm -rf /var/lib/apt/lists/*

# --- GUI tools used by specific labs ---
# If any package name is unavailable in your mirror, drop it and rebuild;
# the CLI equivalent (msfconsole, tshark, ettercap -T, nmap) still works.
RUN apt-get update && apt-get install -y --no-install-recommends \
      zenmap armitage burpsuite wireshark ettercap-graphical \
      tigervnc-viewer x11vnc firefox-esr \
  && rm -rf /var/lib/apt/lists/* || true

# OpenVAS/Greenbone (Lab 5) is large + feed-heavy — install on demand:
#   apt-get install -y gvm && gvm-setup && gvm-start

# credentials + xrdp session
RUN echo 'root:cyberrange' | chpasswd \
 && sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && mkdir -p /run/sshd \
 && echo "xfce4-session" > /root/.xsession \
 && adduser xrdp ssl-cert || true

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 22 3389 7681
CMD ["/usr/local/bin/start.sh"]
