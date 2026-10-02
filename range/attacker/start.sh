#!/bin/sh
# Start dbus, SSH, ttyd, and the XRDP desktop. XRDP runs in the foreground
# so the container stays up.
service dbus start 2>/dev/null || mkdir -p /run/dbus && dbus-daemon --system --fork
service ssh start 2>/dev/null || /usr/sbin/sshd
ttyd -p 7681 -W bash &
rm -f /var/run/xrdp/*.pid 2>/dev/null
/usr/sbin/xrdp-sesman
exec /usr/sbin/xrdp --nodaemon
