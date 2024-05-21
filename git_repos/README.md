# Git Repo Helpful Scripts

## How to setup your computer to interact with one (or more) GitHub accounts using SSH keys
Please refer to my post at this link:
[https://reinerdizonparadis.com/guides/github-ssh-setup/](https://reinerdizonparadis.com/guides/github-ssh-setup/)

You can use the [```github_ssh_setup.sh```](https://raw.githubusercontent.com/reinerdizonparadis/helpful_scripts/main/git_repos/github_ssh_setup.sh)  script to simplify the process.


## How to push all my changes to GitHub (or other services)
You can use the [```push_all_changes.sh```](https://raw.githubusercontent.com/reinerdizonparadis/helpful_scripts/main/git_repos/push_all_changes.sh)  script to simplify the process.

### Basic (Interactive) Usage: 
```bash
./push_all_changes.sh
```
This script will interactively ask the user about staging, committing, and pushing all changes on their repo.


### Advanced (Automated) Usage: 
```bash
./push_all_changes.sh  [-m <commit_msg>] [-p y/n] [-a] [-d <repo_dir>]
```

|Options| Description|
|:----|:----|
|```-m <commit_msg>``` |    Defines the commit message for git commit command<br>|
|```-p <y/n>``` |           Enables/disables pulling from remote repo before pushing to it (Accepts "y" or "n")<br>|
|```-a``` |                 Allows all changes to be staged<br>|
|```-d <repo_dir>``` |      Sets the repo directory other than the current directory<br>|
|```-h``` |                 Shows the usage information

The script with all but the ```-h``` flags will run without the interactive mode.
