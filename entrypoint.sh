#!/bin/bash

# Ensure the log and backup directories exist
mkdir -p ${LOG_DIR}
mkdir -p ${BACKUP_DIR}

# Install or update the 7 Days to Die server
echo "Installing or updating 7 Days to Die server..."
${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${STEAMAPP_DIR} +login ${STEAMAPP_USER} +app_update ${STEAMAPPID} validate +quit
if [ $? -ne 0 ]; then
    echo "Failed to install or update 7 Days to Die server"
    exit 1
fi
echo "7 Days to Die server installed or updated successfully"

# Copy the custom server configuration file
echo "Copying custom server configuration file..."
cp /sdtdServerConfig.xml ${STEAMAPP_DIR}/serverconfig.xml
if [ $? -ne 0 ]; then
    echo "Failed to copy custom server configuration file"
    exit 1
fi
echo "Custom server configuration file copied successfully"

# Start the 7 Days to Die server and redirect logs to the log directory
echo "Starting 7 Days to Die server..."
${STEAMAPP_DIR}/7DaysToDieServer.x86_64 -configfile=${STEAMAPP_DIR}/serverconfig.xml -logfile ${LOG_DIR}/7dtd_server_$(date +%Y%m%d%H%M%S).log &
SERVER_PID=$!
if [ $? -ne 0 ]; then
    echo "Failed to start 7 Days to Die server"
    exit 1
fi
echo "7 Days to Die server started successfully"

# Schedule the backup at 4 AM daily
echo "Scheduling daily backups at 4 AM..."
echo "0 4 * * * /backup.sh" > /etc/cron.d/backup
chmod 0644 /etc/cron.d/backup
crontab /etc/cron.d/backup

# Configure log rotation
echo "Configuring log rotation..."
echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.d/7dtd" > /etc/cron.d/logrotate
chmod 0644 /etc/cron.d/logrotate
crontab /etc/cron.d/logrotate

# Start cron
echo "Starting cron service..."
cron -f