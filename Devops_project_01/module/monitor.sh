#!/usr/bin/bash

set -euo pipefail
IFS=$'\n\t'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/system.log"
MAX_LOG_SIZE=$((5 * 1024 * 1024))  # 5 MB
ROTATE_KEEP=5                      # keep last 5 rotated logs

rotate_logs_if_needed() {
    if [[ -f "$LOG_FILE" ]]; then
        local size
        size=$(stat -c%s "$LOG_FILE")
	if (( size >= MAX_LOG_SIZE )); then
            timestamp=$(date +"%Y%m%d_%H%M%S")
            mv "$LOG_FILE" "${LOG_FILE}.${timestamp}"
            # remove older rotated logs
            ls -1t "${LOG_FILE}."* 2>/dev/null | tail -n +$((ROTATE_KEEP+1)) | xargs -r rm -f
        fi
    fi
}

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

# thresholds (percent)
CPU_WARN=75
MEM_WARN=80
DISK_WARN=85

gather_metrics() {
    # CPU percent over 1 second average
    cpu=$(top -bn1 | awk -F'id,' '/Cpu/ { split($1, vs, ","); for (i in vs) if (vs[i] ~ /[0-9.]+ us/) {gsub(" us","",vs[i]); cpu_user=vs[i]} } END { print 100 - $NF }' || true)
    # fallback
    if [[ -z "$cpu" ]]; then
        cpu=$(grep -E 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5); printf("%.2f", usage)}')
    fi

    mem_used=$(free -m | awk '/Mem:/ {print $3}')
    mem_total=$(free -m | awk '/Mem:/ {print $2}')
    mem_percent=$(awk "BEGIN {printf \"%.2f\", (${mem_used}/${mem_total})*100}")

    disk_percent=$(df -hP / | awk 'NR==2 {gsub("%","",$5); print $5}')

    echo "cpu=${cpu};mem_percent=${mem_percent};disk_percent=${disk_percent}"
}

log_line() {
    local level=$1; shift
    echo "[$(timestamp)] [$level] $*" | tee -a "$LOG_FILE"
}

main() {
    rotate_logs_if_needed
    metrics=$(gather_metrics)
    # shellcheck disable=SC2086
    eval "$metrics"

    # Normalize cpu (some methods returned 12.34)
    cpu_int=$(printf "%.0f" "$cpu")
    mem_int=$(printf "%.0f" "$mem_percent")
    disk_int=$(printf "%.0f" "$disk_percent")

    log_line "INFO" "System metrics - CPU: ${cpu}% | MEM: ${mem_percent}% | DISK: ${disk_percent}%"

    # Warnings
    if (( cpu_int >= CPU_WARN )); then
        log_line "WARN" "CPU usage is high: ${cpu}% (threshold ${CPU_WARN}%)"
    fi
    if (( mem_int >= MEM_WARN )); then
        log_line "WARN" "Memory usage is high: ${mem_percent}% (threshold ${MEM_WARN}%)"
    fi
    if (( disk_int >= DISK_WARN )); then
        log_line "WARN" "Disk usage is high: ${disk_percent}% (threshold ${DISK_WARN}%)"
    fi
}

main

