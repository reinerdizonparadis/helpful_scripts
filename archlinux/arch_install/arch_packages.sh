#!/usr/bin/env bash

# Install pacman packages
sudo pacman -S --noconfirm dolphin power-profiles-daemon
sudo pacman -S --noconfirm bitwarden calibre cups discord docker gwenview gzip imagemagick kcalc kdeconnect keepass konsole krita networkmanager-openconnect okular obs-studio p7zip podofo podofo-tools pam-u2f qbittorrent signal-desktop spectacle thunderbird timeshift unarchiver unzip veracrypt vlc wine zip


# Install yay AUR package helper
sudo pacman -S --needed --noconfirm git 
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -csi
cd ~
rm -rf ~/yay
 

# Install yay packages
yay -S --noconfirm mkinitcpio-firmware brave-bin sublime-text-4
yay -S --noconfirm arduino-ide-bin dataspell drawio-desktop dropbox ipscan networkmanager-openconnect notion-app-electron preload proton-vpn-gtk-app protonmail-bridge teams-for-linux-git ttf-ms-win11-auto yubico-authenticator-bin zoom


# Install QEMU-KVM
sudo pacman -S --noconfirm qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat dmidecode libguestfs
sudo systemctl enable --now libvirtd.service
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt


# Install Printers
sudo pacman -S --noconfirm cups system-config-printer
sudo systemctl enable --now cups
## Canon Printer
yay -S --noconfirm cnijfilter2
## HP Printer
sudo pacman -S --noconfirm hplip

