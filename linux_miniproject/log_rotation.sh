#!/bin/bash

LOG_FIlE="/home/ubuntu/var/log"
BACKUP_DIR="/home/ubuntu/var/log/backup"

mkdir -p $BACKUP_DIR

tar -cvzf $BACKUP_DIR/log_$(date +%y-%m-%d).tar.gz $LOG_FILE/"*.log"

OLD_FILES=$(find "$BACKUP_DIR" -type f -mtime +7 -name "*.tar.gz")
if [ -f $OLD_FILES ];
then
  echo "$OLD_FILES" | xargs rm -rf 
else
"No previous file is there"
fi
