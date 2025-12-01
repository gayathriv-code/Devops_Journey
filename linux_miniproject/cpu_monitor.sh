#!/bin/bash

mkdir -p  ~/cpu_monitor && cd ~/cpu_monitor 
log_file= $(touch ~/cpu_monitor/cpu_moni.log) || exit

cpu_idle= $(top -bn1 | grep "cpu(s)" | awk '{print$8}' |tr -d ' ') | tee -a $log_file
cpu_usage= $((100 - $cpu_idle))| tee -a $log_file

threshold=80

if [ $cpu_usage > $threshold ]
then
echo "cpu has been consumed over"| tee -a $log_file
else
echo "normal function" | tee -a $log_file
fi

ps -eo pid,comm,%cpu --sort=-%cpu | head -n 5 | tee -a $log_file



