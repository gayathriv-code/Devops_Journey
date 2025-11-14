#!/bin/bash

echo "Listing running services with PID..."
echo "----------------------------------------"
printf "%-40s %-10s %-10s\n" "SERVICE NAME" "STATUS" "PID"
echo "----------------------------------------"

if command -v systemctl >/dev/null 2>&1; then
    for service in $(systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}'); do
        status=$(systemctl is-active $service)
        pid=$(systemctl show -p MainPID $service | cut -d'=' -f2)
        [[ $pid -eq 0 ]] && pid="-"
        printf "%-40s %-10s %-10s\n" "$service" "$status" "$pid"
    done
else
    service --status-all 2>/dev/null | grep "+" | while read line; do
        svc_name=$(echo $line | awk '{print $4}')
        status="running"
        pid=$(pgrep -x $svc_name 2>/dev/null | head -n1)
        [[ -z $pid ]] && pid="-"
        printf "%-40s %-10s %-10s\n" "$svc_name" "$status" "$pid"
    done
fi

echo "----------------------------------------"
echo "Done."

