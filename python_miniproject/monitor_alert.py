import psutil
import os
from datetime import datetime

CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=85
SERVICE="nginx"

def event_message(message):
    timestamp=datetime.now().strftime("%y-%m-%d %H:%M:%S")
    with open(os.path.join("/home/ubuntu/var/log/monitor.log","a")) as log:
              log.write(f"{time_stamp}:{message}\n")

def system_info():
    cpu_usage=psutil.cpu_percent(interval=1)
    memory_usage=psutil.virtual_memory().percent
    disk_usage=psutil.disk_usage('/').percent
    return cpu_usage,memory_usage,disk_usage

def restart_service(service):
    event_message(f"this service {service} more use the storage")
    os.system(f"sudo systmctl restart {service}")
    event_message(f"system restarted sucessfully")

cpu,mem,disk=system_info()
if (cpu>CPU_THRESHOLD or mem>MEMORY_THRESHOLD or disk>DISK_THRESHOLD):
              restart_service(SERVICE)
else:
              print("there is no problem in pc")

