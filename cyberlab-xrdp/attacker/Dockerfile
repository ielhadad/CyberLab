# CyberLab attacker image — Kali CLI toolset + a light XFCE desktop over XRDP
# so the GUI labs (Burp, Wireshark, Zenmap, Ettercap, browser) work via RDP.
# Build context: /opt/cyberlab/attacker
FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive

# CLI tools (same set the old inline command installed) + light desktop + xrdp.
# Add the GUI tools your labs need to this list, e.g.: wireshark zaproxy ettercap-graphical
RUN apt-get update && apt-get install -y --no-install-recommends \
      nmap curl iproute2 iputils-ping netcat-openbsd sqlmap hydra nuclei ca-certificates \
      xfce4 xfce4-terminal dbus-x11 xrdp xorgxrdp firefox-esr \
  && rm -rf /var/lib/apt/lists/*

# XRDP session + root login + fix the Kali "colord" auth popup / black screen
RUN echo "xfce4-session" > /root/.xsession \
 && adduser xrdp ssl-cert \
 && echo 'root:cyberrange' | chpasswd \
 && printf '[Allow Colord all Users]\nIdentity=unix-user:*\nAction=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile\nResultAny=no\nResultInactive=no\nResultActive=yes\n' \
    > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla

EXPOSE 3389
# Note: the container's start commands live in docker-compose.yml (command:) so the
# lab route and xrdp startup stay visible/editable there.
