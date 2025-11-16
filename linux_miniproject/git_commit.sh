#!/bin/bash

git add .

echo "Drop your commit message here"
read message
git commit -m "$message"

echo "Enter the branch to push"
read Branch_name

current_branch=$(git branch --show-current)
if [ "$Branch_name" = "$current_branch" ]; then
	git push origin $Branch_name
else
	git checkout $Branch_name
	git push origin $Branch_name
fi



