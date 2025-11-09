#!/bin/bash


echo "SYSTEM INFORAMTION"


mkdir -p ~/Sys_info && cd ~/Sys_info && touch ~/sys_info.txt


echo -e "\nusername of the linux" > sys_info.txt
whoami >> sys_info.txt

echo -e "\ncurrent directory " >> sys_info.txt
pwd >> sys_info.txt

echo -e "\nno of cpu used" >> sys_info.txt
nproc >> sys_info.txt

echo -e "\nno of free memory available" >> sys_info.txt
free -m >> sys_info.txt

echo -e "\nno of free cpu available" >> sys_info.txt
vmstat >> sys_info.txt

echo -e "\nno of free disk available" >> sys_info.txt
iostat >> sys_info.txt



