#!/bin/bash

# Use Reflector to generate initial list of mirrors
printf '[INFO] Use Reflector to generate initial list of mirrors\n'
sudo reflector --save /etc/pacman.d/mirrorlist --protocol https --country "United States" --latest 10 --sort age

# Backup initial list of mirrors
printf '[INFO] Backup initial list of mirrors\n'
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# Use Rankmirrors to rank top 6 mirrors out of the initial list
printf '[INFO] Use Rankmirrors to rank top 6 mirrors out of the initial list\n'
sudo sh -c 'rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist'

# Show current mirrors in /etc/pacman.d/mirrorlist
printf '[INFO] Show current mirrors in /etc/pacman.d/mirrorlist\n'
cat /etc/pacman.d/mirrorlist

