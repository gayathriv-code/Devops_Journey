import os
import subprocess

def run(cmd):
    return subprocess.check_output(cmd,shell=True,text=True).strip()

os.system("git add .")

commit_message=input("enter the commit message")

os.system(f'git commit -m "{commit_message}"')

branch_name=input("enter the branch to push")

current_branch=run("git branch --show-current")

if (branch_name == current_branch):
    os.system(f"git push origin {branch_name}")
else:
    os.system(f"git checkout {branch_name}")
    os.system(f"git push origin {branch_name}")
