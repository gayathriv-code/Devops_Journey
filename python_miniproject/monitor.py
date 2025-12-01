import os
from datetime import datetime
import psutil

def system_info():
    cpu_usage=psutil.cpu_percent(interval=1)
    memory=psutil.virtual_memory()
    disk_usage=psutil.disk_usage("/")
    time_stamp=datetime.now().strftime("%y-%m-%d %H:%M:%S")
    
    info=(
            f"time_stamp\n"
            f"Cpu Usage:{cpu_usage}%\n"
            f"Memory Usage:{memory.percent} of {round(memory.total/(1024**3),2)} GB\n"
            f"Disk Usage: {disk_usage.percent} of {disk_usage.total}\n"
            )
    return info

def log_book(information):
    dir_name="/home/ubuntu/log"
    os.makedirs(dir_name,exist_ok=True)
    log_dir=(os.path.join(dir_name,"monitor.log"))
    with open (log_dir,"a") as log: 
        log.write(information)

if __name__=="__main__":
    data=system_info()
    log_book(data)
    print("log book got the information")


