# CyberLab attacker image — Kali CLI tools + a light XFCE desktop over XRDP,
# so the GUI labs (Burp, Wireshark, Zenmap, Ettercap, browser) work via RDP.
# Startup (xrdp + lab route) is in docker-compose.yml's command:.
FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive

# CLI toolset + light desktop + xrdp. Add GUI tools your labs need here,
# e.g.: wireshark zaproxy ettercap-graphical nikto metasploit-framework
RUN apt-get update && apt-get install -y --no-install-recommends \
      nmap curl iproute2 iputils-ping netcat-openbsd dnsutils \
      sqlmap hydra nuclei john hashcat ca-certificates git \
      xfce4 xfce4-terminal dbus-x11 xrdp xorgxrdp firefox-esr \
  && rm -rf /var/lib/apt/lists/*

RUN echo "xfce4-session" > /root/.xsession \
 && adduser xrdp ssl-cert \
 && echo 'root:cyberrange' | chpasswd \
 && printf '[Allow Colord all Users]\nIdentity=unix-user:*\nAction=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile\nResultAny=no\nResultInactive=no\nResultActive=yes\n' \
    > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla

EXPOSE 3389
