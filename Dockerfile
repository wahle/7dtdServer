# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LGSM_DIR=/home/steam/lgsm
ENV SERVER_DIR=/home/steam/serverfiles
ENV LOG_DIR=/home/steam/logs
ENV BACKUP_DIR=/home/steam/backups
ENV STEAMCMD_DIR=/home/steam/steamcmd

# Enable multi-arch support and install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    curl \
    wget \
    file \
    bzip2 \
    gzip \
    unzip \
    bsdmainutils \
    python3 \
    util-linux \
    ca-certificates \
    binutils \
    bc \
    jq \
    tmux \
    lib32gcc1 \
    lib32stdc++6 \
    libstdc++6:i386 \
    lib32z1 \
    lib32z1-dev \
    libtinfo5:i386 \
    libncurses5:i386 \
    libcurl4-gnutls-dev:i386 \
    cron \
    logrotate

# Create steam user
RUN useradd -m steam

# Switch to steam user
USER steam
WORKDIR /home/steam

# Install SteamCMD
RUN mkdir -p ${STEAMCMD_DIR} && \
    cd ${STEAMCMD_DIR} && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Install LinuxGSM
RUN wget -O linuxgsm.sh https://linuxgsm.sh && \
    chmod +x linuxgsm.sh && \
    bash linuxgsm.sh sdtdserver

# Install 7 Days to Die server
RUN ./sdtdserver install

# Expose ports
EXPOSE 26900-26902/tcp
EXPOSE 26900-26902/udp

# Copy entrypoint script, backup script, logrotate configuration, and server config
COPY entrypoint.sh /entrypoint.sh
COPY backup.sh /backup.sh
COPY logrotate.conf /etc/logrotate.d/7dtd
COPY sdtdServerConfig.xml ${SERVER_DIR}/serverconfig.xml
RUN chmod +x /entrypoint.sh /backup.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]