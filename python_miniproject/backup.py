#!/bin/python3

import os
import shutil
from datetime import datetime
def backup(source):
    destination="/home/ubuntu/backup"
    os.makedirs(destination,exist_ok=True)
    time_stamp=datetime().now().strftime("%y-%m-%d %H:%M:%S")
    backup_file=os.path.join(destination,f"backup_{time_stamp}.zip")
    shutil.make_archive(backup_file.replace(".zip",""),"zip",source)
    return f"backup file was created {backup_file}"


if __name__="__main__":
    source=input("Enter the backup file")
    backup(source)
