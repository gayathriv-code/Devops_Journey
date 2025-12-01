#!/bin/bash


set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$BASE_DIR/log"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/usr_mngt.log"

log(){
	echo "[$(date + "%y-%m-%d %H:%M:%S")].$*" | tee -a "$LOG_FILE"
}

require_root(){
	if [[ $EUID -ne 0 ]]; then
		echo "You do not have root priveliges"
		exit 1
	fi
}

echo "User Management Menu"
echo "1) Create user"
echo "2) Delete user"
echo "3) Lock user"
echo "4) Unlock user"
echo "5) List users"
read -rp "Choose an option [1-5]: " opt

case $opt in 
	1)
		read -rp "Enter the name of the user " user
		require_root
		if id $user &>/dev/null; then 
			log "WARN user is alreay exists"
			exit 1;
		else
		       sudo useradd -m -s /bin/bash $user && log "INFO user created successfully"
		fi
		;;
	2)
		read -rp "Enter the user to delete " user
		require_root
		if id $user &>/dev/null; then
			sudo userdel $user && log "INFO user deleted successfully"
		else
			log "ERROR user does not exists"
		fi
		;;
	3)
		read -rp "enter the user name to lock" user
		require_root
		sudo passwd -l $user && log "INFO user is locked successfully"
		;;
	4)
		read -rp "enter the user name to unlock" user
		require_root
		sudo passwd -u $user && log "INFO user is unlocked successfully"
		;;
	5)
		echo "list of user"
		awk -F: '{if ($3>1000 && $3<65534) print $1}' /etc/passwd 
		;;
	*)
		echo "invalid option"
		exit 1
		;;
esac
