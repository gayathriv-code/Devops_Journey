#!/bin/bash

user_file="user_name.txt"
password="example@123"

while read user; do
    user=$(echo "$user" | tr -d '\r' | tr '[:upper:]' '[:lower:]' | xargs)
    [ -z "$user" ] && continue

    if id "$user" &>/dev/null; then
        echo "User $user already exists."
    else
        sudo useradd -m -s /bin/bash "$user"
        echo "$user:$password" | sudo chpasswd
        echo "✅ User $user added with default password."
    fi
done < "$user_file"

