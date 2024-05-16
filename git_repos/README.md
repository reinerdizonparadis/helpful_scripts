# How to setup your computer to interact with one (or more) GitHub accounts using SSH keys?
**Note:** GitHub (and others) require that you to set up different SSH keys for each separate GitHub account and each computer.<br>
**Note:** The following example assumes you are using GitHub as your remote repository hosting service. You can perform most of these operations in GitLab and other services.

## Please read the whole document before proceeding.
You can download the setup script at [this link](https://raw.githubusercontent.com/reinerdizonparadis/helpful_scripts/main/git_repos/github_ssh_setup.sh).

## Pre-requisites:
<details>
    <summary>Install git, make SSH config files, and make a SSH keys folder</summary><br>
    
1) Make sure the packages for ```git``` and ```ssh``` are installed on your computer.
* On Windows, please install [Git Bash](https://git-scm.com/download/win), which has both packages. 
* On Mac OS, these can be installed using [homebrew](https://git-scm.com/download/mac) or its alternatives.
* On Linux, you can install [these packages](https://git-scm.com/download/linux) using your distro's package manager (e.g., apt, pacman, rpm, etc.). 

2) Open Git Bash or your terminal after installation.


3) Make a SSH directory if it does not exist.
```bash
SSH_DIR=~/.ssh
if [ -d "$SSH_DIR" ]; then
    echo "$SSH_DIR exists."
else 
    echo "$SSH_DIR does not exist, making .ssh directory now."
    mkdir -p $SSH_DIR
fi
```


4) Make a SSH configuration file if it does not exist.
```bash
SSH_CONFIG_FILE=~/.ssh/config
if [ -f "$SSH_CONFIG_FILE" ]; then
    echo "$SSH_CONFIG_FILE exists."
else 
    echo "$SSH_CONFIG_FILE does not exist, making config file now."
    touch $SSH_CONFIG_FILE
fi
```

5) Make a folder of SSH keys for your GitHub accounts for better organization.
```bash
mkdir -p ~/.ssh/github
```
**Note:**
* You can replace ```github``` with your remote repo service.

</details>


---


## Setting up an SSH key for one GitHub account for one computer
<details>
    <summary>Create new SSH key and add custom GitHub host to SSH config file</summary><br>


1) Define the following variables:
```bash
# replace <username> with your GitHub username
GITHUB_USERNAME=<username> 

# (Optional) You can use the default "HOSTNAME" environment variable or redefine <hostname> to something that reminds you of this computer (e.g., "home" for home computer, "work" for work computer, etc.)
HOSTNAME=<hostname>
```


2) Create new a SSH key for one of your GitHub accounts.
```bash
# Use this if you want to login using only password/passphrase
ssh-keygen -t ed25519 -C "${HOSTNAME}_gh_${GITHUB_USERNAME}" -f ~/.ssh/github/gh_${GITHUB_USERNAME}

# OR

# Use this if you want to login with a physical hardware key (e.g., Yubikey)
# With an option to authenticate password/passphrase (like 2FA)
ssh-keygen -t ed25519-sk -C "${HOSTNAME}_gh_${GITHUB_USERNAME}" -f ~/.ssh/github/gh_${GITHUB_USERNAME}
```
**Notes:**
* After you run this command and see the ASCII art, there will be two files generated:
    * ```~/.ssh/github/gh_${GITHUB_USERNAME}``` - private SSH key (without file extension)
    * ```~/.ssh/github/gh_${GITHUB_USERNAME}.pub``` - public SSH key (with ```.pub``` file extension)


3) Add your custom GitHub account host to SSH configuration file.
```bash
printf "Host gh_${GITHUB_USERNAME}\n\tHostname github.com\n\tIdentityFile ~/.ssh/github/gh_${GITHUB_USERNAME}\n\n" >> ~/.ssh/config
```

4) You may repeat Steps 1-3 for every GitHub account you want to set up on your computer.

</details>

---


## Connect your computer to your GitHub via SSH (using your private key)
<details>
    <summary>Run SSH agent and add your private key to the SSH agent</summary><br>

0) (***Optional***) If you generated multiple SSH keys for different GitHub accounts, make sure that the ```GITHUB_USERNAME``` environment variable is set up correctly for every SSH private key you are adding to the SSH agent.
```bash
# replace <username> with your GitHub username
GITHUB_USERNAME=<username>
```

1) Create SSH connection from your computer to GitHub using the SSH agent (in the background).
```bash
eval $(ssh-agent -s)
```

2) Add your SSH private key to the SSH agent.
```bash
# Repeat for all SSH private keys of every GitHub account you have set up
ssh-add ~/.ssh/github/gh_${GITHUB_USERNAME}
```


3) (***Optional***) Make ```ssh-agent``` run automatically when you open your Git Bash/terminal.
```bash
# Add "ssh-agent" command to your ".bashrc" file (only needs to be done ONCE PER MACHINE)
echo "eval \$(ssh-agent -s)" >> ~/.bashrc
```


4) (***Optional***) Make ```ssh-add``` run automatically when you open your Git Bash/terminal.
```bash
# Add "ssh-add" command to your ".bashrc" file (need to be done ONCE PER GITHUB ACCOUNT)
echo "ssh-add ~/.ssh/github/gh_${GITHUB_USERNAME}" >> ~/.bashrc
```

</details>

---


## Add your SSH public key to GitHub
<details>
    <summary>Grab your SSH public key and add it to your GitHub account</summary><br>

0) (***Optional***) If you generated multiple SSH keys for different GitHub accounts, make sure that the ```GITHUB_USERNAME``` environment variable is set up correctly for every SSH public key you are about add to different GitHub accounts.
```bash
# replace <username> with your GitHub username
GITHUB_USERNAME=<username>
```

1) Display your public SSH key to the terminal for easy copy/paste.
```bash
cat ~/.ssh/github/gh_${GITHUB_USERNAME}.pub
```

2) Sign in to your GitHub account.

3) Click on your profile picture on the top right. Click on ```Settings```.

4) Click on ```SSH and GPG keys``` under the Access group on the left side of the settings.

5) Click on the button called ```New SSH key```. 

6) Paste in the SSH public key in the ```Key``` text box. Leave ```Title``` text box empty and all other settings the same.

7) Click ```Add SSH key```.

8) (***Optional***) If you are setting up different computers (with different SSH keys) to the same GitHub account, repeat Steps 0-7 for every computer you want to add to your GitHub account. Make sure ```GITHUB_USERNAME``` is the same for every computer.

9) (***Optional***) If you have multiple GitHub accounts, repeat Steps 0-7 on the same machine. Make sure ```GITHUB_USERNAME``` is the different after you completed adding the keys for each account.

</details>

---


## Using SSH keys after setup
These steps assumed that the SSH agent is running, and you have added the SSH key for your account to the SSH agent. Please refer to the previous section. 


### Cloning a GitHub repo to your local computer
<details>
    <summary>Clone your GitHub repo with the new host and configure your username/private commit email of your repo.</summary><br>

1) Grab the SSH link for your GitHub repo. It should look like: ```git@github.com:<username>/<repo_name>.git```

2) Replace ```github.com``` from step 1 with ```gh_${GITHUB_USERNAME}``` when cloning your repo.
```bash
git clone git@gh_<username>:<username>/<repo_name>.git
```

3) Navigate into your (newly cloned) local GitHub repository.
```bash
cd <repo_name>/
```

4) (***Optional***) If you have (or may have) multiple GitHub accounts, reset the global configuration for ```git``` username and email.
```bash
# Do only ONCE per computer
git config user.name --global ""
git config user.email --global ""
```

5) Add your GitHub account's username and email to this repo<br>
For privacy, I recommend replacing ```<email>``` with either your Github email<sup>1</sup> or the private GitHub commit email <sup>2</sup>
```bash
# Do for each repo per computer 
git config user.name <username>
git config user.email <email>
```
**Notes:**<br>
<sup>1</sup> Be sure to replace ```<email>``` with your GitHub's email.<br>
<sup>2</sup> For additional security, [GitHub](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address) allows you to hide your email and provides you with a commit email address. You can use this provided email, rather than the actual GitHub email.

</details>

---


### Editing the configuration of a local repo already cloned from a GitHub account
<details>
    <summary>Edit the config file inside ".git" directory with the new host of your GitHub account.</summary><br>

1) Navigate to your (already cloned) local GitHub repo.
```bash
cd <path/to/repo>/
```

2) Allow your file manager to show hidden files.
* For Windows, refer to this [link](https://support.microsoft.com/en-us/windows/view-hidden-files-and-folders-in-windows-97fbc472-c603-9d90-91d0-1166d1d9f4b5)
* For Mac, refer to this [link](https://www.howtogeek.com/how-to-show-search-hidden-files-mac/)
* For Ubuntu Linux, refer to this [link](https://itsfoss.com/show-hidden-files-linux/)
* For other Linux distros, please search the Internet for your particular desktop environment (DE).

3) Open the ```.git/config``` inside your repository using any text editor

4) Locate the line: ```url = git@github.com:<username>/<repo_name>.git```

5) Replace ```github.com``` with ```gh_<username>```. This line will now look like ```url = git@gh_<username>:<username>/<repo_name>.git```

6) Save the configuration file.

</details>

---

