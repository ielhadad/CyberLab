# CAI (Cybersecurity AI) container for Tiny CyberLab.
# CAI ships as a pip package (cai-framework), not an official image, so we build
# a small Kali-based image around it with a few tools CAI can drive, plus ttyd
# and SSH for access. CAI calls an external LLM API — supply a key via cai.env.
FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive
# PROMPT_TOOLKIT_NO_CPR=1 is recommended by the CAI docs for container terminals
ENV PROMPT_TOOLKIT_NO_CPR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
      nmap netcat-traditional curl wget iputils-ping dnsutils git \
      openssh-server ttyd \
  && rm -rf /var/lib/apt/lists/*

# Install CAI (the 'cai' CLI lands on PATH)
RUN pip install --break-system-packages cai-framework

# Lab access credentials
RUN echo 'root:cyberrange' | chpasswd \
 && sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && mkdir -p /run/sshd

EXPOSE 22 7682
# ttyd serves an interactive CAI session in the browser; SSH is the fallback.
CMD ["/bin/sh","-c","service ssh start; ttyd -p 7682 -W cai || ttyd -p 7682 -W bash"]
