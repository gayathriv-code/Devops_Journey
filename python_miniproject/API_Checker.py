#!/bin/python3

import requests
from datetime import datetime
import os


def api_checker(url):
 try:
    response=requests.get(url,timeout=5)
    if response.statuscode==200:
        return f"UP"
    else:
        return f"down with {response.statuscode}-->{url}"
 except Exception as e:
     return f"down error {e}"

if __name__ =="__main__":
    url="https://google.com"
    status=api_checker(url)
    time_stamp=datetime.now().strftime("%y-%m-%d %H:%M:%S")
    dir_path="/home/ubuntu/var/log"
    os.makedirs(dir_path,exist_ok=True)
    log_file=os.path.join(dir_path,"api_checker.log")
    with open (log_file,"a") as log:
        log.write(f"{time_stamp}--->{url}--->{status}")
    print(f"{time_stamp} → {url} → {status}")
