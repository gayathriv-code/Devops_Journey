#/bin/bash


LOG_FILE="/home/ubuntu/var/log"
BACKUP_FILE="/home/ubuntu/var/log/backup"

tar -cvzf $BACKUP_FILE/backup_$(date +%y-%m-%d).tar.gz  $LOG_FILE/*.log

OLD_FILE=$(find $BACKUP_FILE -type f -mtime +7 -name "*.tar.gz")

if [ -n $OLD_FILES ]; then
	echo "$OLD_FILES" | xargs rm -rf
else
	echo "no old file is present"
fi
