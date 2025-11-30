#!/usr/bin/env bash
# main.sh - Menu orchestrator for DevOps Automation Suite
set -euo pipefail
IFS=$'\n\t'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$BASE_DIR/module"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

print_header() {
    echo "========================================="
    echo "   DevOps Automation Suite - Main Menu   "
    echo "========================================="
}

pause() {
    read -rp "Press Enter to continue..."
}

while true; do
    clear
    print_header
    echo "1) System Monitoring"
    echo "2) Backup Manager"
    echo "3) User Management"
    echo "4) View Logs"
    echo "5) Exit"
    echo "-----------------------------------------"
    read -rp "Choose an option [1-5]: " choice || choice=5

    case "$choice" in
        1)
            bash "$MODULE_DIR/monitor.sh"
            pause
            ;;
        2)
            bash "$MODULE_DIR/backup.sh"
            pause
            ;;
        3)
            sudo bash "$MODULE_DIR/usr_mngt.sh"
            pause
            ;;
        4)
            echo "Logs are located at: $LOG_DIR"
            ls -lah "$LOG_DIR" || true
            echo
            read -rp "Enter logfile to tail (or leave empty to cancel): " lf
            if [[ -n "$lf" && -f "$LOG_DIR/$lf" ]]; then
                tail -n 200 -f "$LOG_DIR/$lf"
		pause
            fi
            ;;
        5)
            echo "Exiting. Goodbye."
            exit 0
            ;;
        *)
            echo "Invalid option: $choice"
            sleep 1
            ;;
    esac
done
