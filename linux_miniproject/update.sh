#!/bin/bash

touch /home/ubuntu/var/log/update.txt

LOG_FILE="/home/ubuntu/var/log/update.txt"
EMAIL="gayathri.v.official05@gmail.com"

sudo apt update -y | tee -a $LOG_FILE 2>&1
UPDATE_STATUS=$?

sudo apt upgrade -y | tee -a $LOG_FILE  2>&1
UPGRADE_STATUS=$?

if [ $UPDATE_STATUS -ne 0 ] || [ $UPGRADE_STATUS -ne 0]; then
	echo "problem in update" | tee -a $LOG_FILE
	echo "error in update and upgrade" | mail -s "update_status" $EMAIL<$LOG_FILE 
else
	echo "updated successfully" | tee -a $LOG_FILE
fi



