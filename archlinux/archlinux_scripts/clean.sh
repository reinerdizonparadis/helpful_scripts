#!/bin/bash

sudo pacman -Sc --noconfirm
yay -Sc --noconfirm
sudo paccache -ruk0
sudo pacman -Qdtq | sudo pacman -Rns -
