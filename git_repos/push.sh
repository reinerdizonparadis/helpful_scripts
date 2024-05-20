#!/usr/bin/env bash
# script file for staging, committing, and pushing to the remote repo (all changes and additions)

set -e

pull_before_push_flag=""
pull_before_push=false
add_flag=false
repo_dir=""
commit_msg=""

print_usage() {
  printf "Usage: $0  [-m <commit_msg>] [-p y/n] [-a] [-d <repo_dir>]\n"
  printf "Options:\n"
  printf "  -m <commit_msg> ,    Defines the commit message for git commit command\n"
  printf "  -p <y/n> ,           Enables/disables pulling from remote repo \n" 
  printf "                       before pushing to it (Accepts \"y\" or \"n\")\n"
  printf "  -a ,                 Allows all changes to be staged\n"
  printf "  -d <repo_dir> ,      Sets the repo directory other than the current directory\n"
}


while getopts 'm:p:ad:h' OPTION; do
  case "$OPTION" in
    m)
      commit_msg="$OPTARG"
      ;;
    p)
      pull_before_push_flag="$OPTARG"
      ;;
    a)
	  add_flag=true
	  ;;
    d)
      repo_dir="$OPTARG"
      ;;
    h)
      print_usage
      exit 0
      ;;
    ?)
      print_usage
      exit 1
      ;;
  esac
done


# Ask user if the current directory has the repo.
if [[ ${repo_dir} == "" ]]; then
	printf "\n[INFO] Current directory: $(pwd)\n\n"
	read -p "Are you in the current directory of your repo? (Y/n): " confirm
	if [[ $confirm == [nN] || $confirm == [nN][oO] ]]; then
		printf "\n"
		read -p "Provide the repo directory: " repo_dir
	else
		repo_dir=$(pwd)
	fi
fi


# Change directory if repo directory is different from current directory
if ! [[ ${repo_dir} == "" ]] && [ ${repo_dir} != $(pwd) ]; then
	cd ${repo_dir}
fi
printf "\n[INFO] Repo directory: $(pwd)\n\n"


# Interactively asking user if they want to pull (if the '-p' was not passed)
if [ "${pull_before_push_flag}" == "" ] ; then
	read -p "Do you want to pull from remote repo before pushing to it? (y/N): " confirm 
	if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		pull_before_push=true
	else
		pull_before_push=false
	fi
elif [[ ${pull_before_push_flag} == [yY] ]] ; then
	pull_before_push=true
else
	pull_before_push=false
fi


# Pulling the remote repo for any changes
if ${pull_before_push} ; then
	printf "\n[INFO] Pulling from the remote repo for any changes...\n"
	git pull
	printf "\n[OK] Pull complete \n\n"
fi


# Ask user if they want to proceed
if ! ${add_flag} ; then
	read -p "Do you want to stage all your changes/additions? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
	add_flag=true
fi


# Staging all changes/additions
printf "\n[INFO] Staging all your changed/new files...\n"
git add --all
printf "\n[OK] All changes/additions have been staged, ready to commit\n\n"


# Ask user for commit if the message was not passed as an argument with "-m" flag
while [[ ${commit_msg} == "" ]] ; do
	read -p "Please add your commit message: " commit_msg
done

# Committing changes	
printf "\n[INFO] Committing all changes on the local repo\n"
git commit -m "${commit_msg}"
printf "\n[OK] Changes committed, ready to push\n\n"


# Pushing the commit to the remote repo
printf "\n[INFO] Pushing the commit to the remote repo\n"
git push
printf "\n[OK] Push done\n\n"


# Pulling from the remote repo to double check
printf "\n[INFO] Pulling from remote repo to double check\n\n"
git pull
printf "\n[OK] Double check done, exiting now...\n\n"
