#!/bin/bash

# Define backup file name
BACKUP_FILE="${BACKUP_DIR}/7dtd_backup_$(date +%Y%m%d%H%M%S).tar.gz"

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Stop the server
docker stop 7dtd_server

# Create a backup
tar -czvf ${BACKUP_FILE} -C ${STEAMAPP_DIR} .

# Start the server
docker start 7dtd_server

# Delete older backups, keeping only the last 7
cd ${BACKUP_DIR}
ls -t | sed -e '1,7d' | xargs -d '\n' rm -f

# Print backup file location
echo "Backup created: ${BACKUP_FILE}"