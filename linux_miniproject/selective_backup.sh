#!/bin/bash

mkdir -p ~/backup && cd ~/backup


echo "enter the directory to backup"
read dir_name

if [ -d ~/$dir_name ]
then
tar -czvf ~/backup/backup_$(date +%y-%m-%d-%H-%M-%S).tar.gz  /home/ubuntu/$dir_name
else
echo "no such directory is found"
fi


if [ -f ~/backup/backup_$(date +%y-%m-%d-%H-%M-%S).tar.gz ]
then
echo "tar file is created"
else
echo "there is error in the program"
fi


