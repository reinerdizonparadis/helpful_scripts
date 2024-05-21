#!/usr/bin/env bash
# script file for staging, committing, and pushing to the remote repo (all changes and additions)

# Fail the script when one of the commands fail
set -e


# Variables
pull_before_push_flag=""
pull_before_push=false
add_flag=false
repo_dir=""
commit_msg=""


# Print Usage
print_usage() {
  printf "Usage: $0  [-m <commit_msg>] [-p <y/n>] [-a] [-D <commit_msg>] [-d <repo_dir>]\n"
  printf "Options:\n"
  printf "  -m <commit_msg> ,    Define the commit message for git commit command\n"
  printf "  -p <y/n> ,           Enable/disable pulling from remote repo \n" 
  printf "                       before pushing to it (Accepts \"y\" or \"n\")\n"
  printf "  -a ,                 Allow all changes to be staged\n"
  printf "  -D <commit_msg> ,    Use default options and pass on the commit message\n"
  printf "                       (pull before push, stage all changes, use current path)\n"
  printf "  -d <repo_dir> ,      Set the repo directory other than the current directory\n"
}


# Argument parsing
while getopts 'm:p:ad:D:h' OPTION; do
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
    D)
      pull_before_push_flag="y"
      add_flag=true
      repo_dir=$(pwd)
      commit_msg="$OPTARG"
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
if [[ -z ${repo_dir} ]]; then
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
if [[ -n ${repo_dir} ]] && [[ ${repo_dir} != $(pwd) ]]; then
  repo_dir=${repo_dir/#\~/$HOME}
  cd ${repo_dir}
fi
printf "\n[INFO] Repo directory: $(pwd)\n\n"


# Interactively asking user if they want to pull (if the '-p' was not passed)
if [[ -z ${pull_before_push_flag} ]] ; then
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
  read -p "Do you want to stage all your changes/additions? (y/N): " confirm && \
    [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || (printf "\n[INFO] Exiting now...\n\n"; exit 1)
  add_flag=true
fi


# Staging all changes/additions
printf "\n[INFO] Staging all your changed/new files...\n"
git add --all
printf "\n[OK] All changes/additions have been staged, ready to commit\n\n"


# Ask user for commit if the message was not passed as an argument with "-m" flag
while [[ -z ${commit_msg} ]] ; do
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
printf "\n[OK] Double check done, Exiting now...\n\n"
