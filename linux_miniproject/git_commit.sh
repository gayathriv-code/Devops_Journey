#!/bin/bash


echo "enter the url or ssh to clone"
read url

git clone $url
Repo_name=$(basename -s .git $url)

cd $Repo_name
echo "Now you can make changes"
read -n 1

git add .
echo "enter the git commit comment"
read commend 

git commit -m $commend


echo "enter the branch name"
read branchs
branch_current=$(git branch --show-current)
if ("$branchs" != "$branch_current")
then
git branch checkout $branchs
git push origin $branch
else
git push origin $branch

