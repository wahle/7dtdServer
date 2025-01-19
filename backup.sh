#!/bin/bash

# Define backup file name
BACKUP_FILE="${BACKUP_DIR}/7dtd_backup_$(date +%Y%m%d%H%M%S).tar.gz"

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Stop the server
/home/steam/sdtdserver stop

# Create a backup
tar -czvf ${BACKUP_FILE} -C ${SERVER_DIR} .

# Start the server
/home/steam/sdtdserver start

# Delete older backups, keeping only the last 7
cd ${BACKUP_DIR}
ls -t | sed -e '1,7d' | xargs -d '\n' rm -f

# Print backup file location
echo "Backup created: ${BACKUP_FILE}"