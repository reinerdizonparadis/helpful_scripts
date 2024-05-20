#!/bin/bash

###############################################################
# Variables
###############################################################
ADD_OTHER_ACCT=true
REPO_ACCTS=()
REMOTE_REPO_SRVC="GitHub"
REMOTE_REPO_SRVC_SHORT="gh"

###############################################################
# Introduction
###############################################################
# Usage guide
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    printf "[INFO] Default Usage: Assumes GitHub as the remote repo service\n"
    printf "\t\t$ ./github_ssh_setup.sh\n\n"
    
    printf "[INFO] Advanced Usage: Changes the remote repo service to the first two arguments to the bash script\n\n"
    printf "\t\t$ ./github_ssh_setup.sh [<Remote Repo Service> <Abbr for Remote Repo Service>]\n\n"
    printf "       Example Usage:\n"
    printf "\t\t$ ./github_ssh_setup.sh GitHub gh\n\n"
    exit 0
fi


# Replace RRS names if passed as arguments to the script
if ! [ "$1" == "" ] && ! [ "$2" == "" ]; then
    REMOTE_REPO_SRVC=$1
    REMOTE_REPO_SRVC_SHORT=$2
fi

# Modified 
RRS="${REMOTE_REPO_SRVC,,}"
RRS_SHORT="${REMOTE_REPO_SRVC_SHORT,,}"




printf "
###############################################################
# GitHub SSH Setup
###############################################################
"
printf "\n Remote Repo Service: ${REMOTE_REPO_SRVC}"
printf "\n Remote Repo Service (Short): ${REMOTE_REPO_SRVC_SHORT}"
printf "\n\n"

###############################################################
# Pre-requisites
###############################################################

# Make a SSH directory if it does not exist.
SSH_DIR=~/.ssh
if [ -d "$SSH_DIR" ]; then
    echo "[INFO] $SSH_DIR exists, moving on."
else 
    echo "[INFO] $SSH_DIR does not exist, making $SSH_DIR directory now."
    read -p "Continue? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    mkdir -p $SSH_DIR
fi
printf "\n\n"


# Make a SSH configuration file if it does not exist.
SSH_CONFIG_FILE=~/.ssh/config
if [ -f "$SSH_CONFIG_FILE" ]; then
    echo "[INFO] $SSH_CONFIG_FILE exists, moving on."
else 
    echo "[INFO] $SSH_CONFIG_FILE does not exist, making config file now."
    touch $SSH_CONFIG_FILE
fi
printf "\n\n"


# Make a folder of SSH keys for your GitHub accounts for better organization.
SSH_RRS_DIR=~/.ssh/${RRS}
if [ -d "$SSH_RRS_DIR" ]; then
    echo "[INFO] $SSH_RRS_DIR exists, moving on."
else 
    echo "[INFO] $SSH_RRS_DIR does not exist, making $SSH_RRS_DIR directory now."
    read -p "Continue? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    mkdir -p $SSH_RRS_DIR
fi
printf "\n\n"


###############################################################
# Setting up an SSH key for one GitHub account for one computer
###############################################################

# Define the hostname:
echo "[INFO] Your computer's name (hostname) is: $HOSTNAME"
read -p "Would you like to change it? (y/N): " confirm 
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    read -p "Enter the new hostname: " HOSTNAME
    echo "[INFO] Your new hostname is $HOSTNAME."
fi
printf "\n\n"


while [ $ADD_OTHER_ACCT == true ]; do

    # Define the GitHub username
    read -p "Enter your ${REMOTE_REPO_SRVC} username: " REPO_USERNAME
    printf "\n\n"
    

    # Create new a SSH key for one of your GitHub accounts.
    echo "[INFO] Creating a new SSH key pair for $REPO_USERNAME account."
    ssh-keygen -t ed25519 -C "${HOSTNAME}_${RRS_SHORT}_${REPO_USERNAME}" -f ${SSH_RRS_DIR}/${RRS_SHORT}_${REPO_USERNAME}
    printf "\n\n"


    # Add your custom GitHub account host to SSH configuration file.
    echo "[INFO] Adding a custom host for your $REPO_USERNAME account to $SSH_CONFIG_FILE file."
    printf "Host ${RRS_SHORT}_${REPO_USERNAME}\n\tHostname ${RRS}.com\n\tIdentityFile ${SSH_RRS_DIR}/${RRS_SHORT}_${REPO_USERNAME}\n\n" >> $SSH_CONFIG_FILE
    printf "\n\n"
    
    # Adding to GitHub account arrays
    REPO_ACCTS+=($REPO_USERNAME)
    
    
    # Prompt for other accounts
    read -p "Would you like to add another account? (y/N): " confirm
    case $confirm in
        [Yy]* ) ADD_OTHER_ACCT=true;;
        * ) ADD_OTHER_ACCT=false;;
    esac
    printf "\n\n"
    
done


###############################################################
# Add your SSH public key to GitHub
###############################################################

echo "
[INFO] Please follow these instructions on your GitHub account:
1) Sign in to your GitHub account.
2) Click on your profile picture on the top right. Click on \"Settings\".
3) Click on \"SSH and GPG keys\" under the Access group on the left side of the settings.
4) Click on the button called \"New SSH key\". 
5) Paste in the SSH public key in the \"Key\" text box. Leave \"Title\" text box empty and all other settings the same.
6) Click \"Add SSH key\".
"

read -p "Press [ENTER] to proceed: " confirm

for REPO_ACCT in "${REPO_ACCTS[@]}"; do
    printf "\n\n[INFO] Opening SSH public key for ${RRS_SHORT}_${REPO_ACCT}. Copy this to your ${REMOTE_REPO_SRVC} account.\n\n"
    cat ~/.ssh/${RRS}/${RRS_SHORT}_${REPO_ACCT}.pub
    printf "\n"
    read -p "Press [ENTER] when you are done adding the SSH key for ${REPO_ACCT}: " confirm
done
printf "\n\n"

###############################################################
# Connect your computer to your GitHub via SSH (using your private key)
###############################################################

read -p "Want to set up SSH-agent? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
printf "\n\n"

# Create SSH connection from your computer to GitHub using the SSH agent (in the background).
echo "[INFO] Open SSH agent in the background."
eval $(ssh-agent -s)
printf "\n\n"

# Add your SSH private key to the SSH agent.
for REPO_ACCT in "${REPO_ACCTS[@]}"; do
  echo "[INFO] Adding SSH key for ${REPO_ACCT} account to SSH agent."
  ssh-add ${SSH_RRS_DIR}/${RRS_SHORT}_${REPO_ACCT}
done
printf "\n\n"



# Prompt for adding ssh-agent in ~/.bashrc file
read -p "Would you like to add \`ssh-agent\` to ~/.bashrc file? (y/N): " confirm 
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    printf "\n\neval \$(ssh-agent -s)\n" >> ~/.bashrc
fi
printf "\n\n"


# Prompt for adding ssh-add for all keys in ~/.bashrc file
read -p "Would you like to add \`ssh-add\` for all SSH keys to ~/.bashrc file? (y/N): " confirm 
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    printf "\n\n" >> ~/.bashrc
    for REPO_ACCT in "${REPO_ACCTS[@]}"; do
      printf "ssh-add ${SSH_RRS_DIR}/${RRS_SHORT}_${REPO_ACCT}\n" >> ~/.bashrc
    done
fi
printf "\n\n"

# Run Terminal once more
bash -i
