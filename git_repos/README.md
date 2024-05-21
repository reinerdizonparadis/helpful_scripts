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
./push_all_changes.sh  [-m <commit_msg>] [-p <y/n>] [-a] [-D] [-d <repo_dir>]
```

|Options| Description|
|:----|:----|
|```-m <commit_msg>``` |    Define the commit message for git commit command|
|```-p <y/n>``` |           Enable/disable pulling from remote repo before pushing to it (Accepts "y" or "n")|
|```-a``` |                 Allow all changes to be staged|
|```-d <repo_dir>``` |      Set the repo directory other than the current directory|
|```-D <commit_msg>``` |    Use default options and pass on the commit message (pull before push, stage all changes, use current path)|
|```-h``` |                 Show the usage information|

The script with all but the ```-h``` flags will run without the interactive mode.


### (For Windows) Using the script in Command Prompt in Interactive Mode
* Make sure you have [Git Bash](https://git-scm.com/download/win) installed.
* You will need both [```push_all_changes.sh```](https://raw.githubusercontent.com/reinerdizonparadis/helpful_scripts/main/git_repos/push_all_changes.sh) and [```upload_to_github.bat```](https://raw.githubusercontent.com/reinerdizonparadis/helpful_scripts/main/git_repos/upload_to_github.bat) scripts in the same folder.

Open ```Command Prompt``` in the folder where the scripts are located and type the following command:
```cmd
upload_to_github.bat
```
