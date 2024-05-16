#!/bin/bash
# script file for committing

if [ "$1" == "" ]; then
	echo "Empty message Error: Need a commit message in \"quotes\""
	exit 1
fi

git pull
printf "\n*** Pull complete\n\n"
git add .
git commit -m "$1"
printf "\n*** Changes committed, ready to push: git push\n\n"
git push
printf "\n*** Push done, pull to double check\n\n"
git pull
printf "\n*** Double check done, exiting now...\n\n"
