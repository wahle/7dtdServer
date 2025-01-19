# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables
ENV STEAMCMD_DIR=/steamcmd
ENV STEAMAPPID=294420
ENV STEAMAPP_DIR=/7dtd
ENV STEAMAPP_USER=anonymous
ENV LOG_DIR=/logs
ENV BACKUP_DIR=/backups

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    lib32gcc1 \
    lib32stdc++6 \
    curl \
    unzip \
    cron \
    logrotate

# Install SteamCMD
RUN mkdir -p ${STEAMCMD_DIR} && \
    cd ${STEAMCMD_DIR} && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Expose ports
EXPOSE 26900-26902/tcp
EXPOSE 26900-26902/udp
EXPOSE 8080/tcp
EXPOSE 8081/tcp
EXPOSE 8082/tcp

# Copy entrypoint script, backup script, logrotate configuration, and server config
COPY entrypoint.sh /entrypoint.sh
COPY backup.sh /backup.sh
COPY logrotate.conf /etc/logrotate.d/7dtd
COPY sdtdServerConfig.xml /sdtdServerConfig.xml
RUN chmod +x /entrypoint.sh /backup.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]