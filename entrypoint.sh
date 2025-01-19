#!/bin/bash

# Ensure the log and backup directories exist
mkdir -p ${LOG_DIR}
mkdir -p ${BACKUP_DIR}

# Copy the custom server configuration file
echo "Copying custom server configuration file..."
cp ${SERVER_DIR}/serverconfig.xml ${SERVER_DIR}/serverconfig.xml
if [ $? -ne 0 ]; then
    echo "Failed to copy custom server configuration file"
    exit 1
fi
echo "Custom server configuration file copied successfully"

# Start the 7 Days to Die server using LinuxGSM
/home/steam/sdtdserver start

# Schedule the backup at 4 AM daily
echo "0 4 * * * /backup.sh" > /etc/cron.d/backup
chmod 0644 /etc/cron.d/backup
crontab /etc/cron.d/backup

# Configure log rotation
echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.d/7dtd" > /etc/cron.d/logrotate
chmod 0644 /etc/cron.d/logrotate
crontab /etc/cron.d/logrotate

# Start cron
cron -f