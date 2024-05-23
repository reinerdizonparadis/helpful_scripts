#!/usr/bin/env bash

## (Optional) Change Terminal Font Size
setfont -d


## Check if booted in UEFI mode
efivar -l


## Get Wi-Fi Internet Working (Optional)
iwctl
device list                     # Get Wi-Fi devices (e.g., wlan0)
station wlan0 get-networks      # Get networks
station wlan0 connect <ssid>    # Connect by typing password
ping -c4 google.com


## Format Disk
lsblk
gdisk /dev/nvme0n1
x # Expert Mode
z # Format Disk


## Partition Disk
cgdisk /dev/nvme0n1
##################################################################
# Size          Partition Type                  Partition Name
# 1024MiB       EFI System Partition (EF00)     name: boot
# 15686MiB      Swap (8200)                     name: swap
# 40GiB         Ext4 (8300)                     name: root
# remaining     Ext4 (8300)                     name: home
##################################################################
# Press on Write, then Quit
##################################################################


## Format Partitions
mkfs.fat -F32 /dev/nvme0n1p1    # partition: boot
mkswap /dev/nvme0n1p2           # partition: swap
swapon /dev/nvme0n1p2           # turn on swap
mkfs.ext4 /dev/nvme0n1p3        # partition: root
mkfs.ext4 /dev/nvme0n1p4        # partition: home


## Mount Partitions
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p4 /mnt/home


## Find best mirrors
pacman -Sy pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist


## Install Arch Linux
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers sof-firmware networkmanager bluez bluez-utils pipewire nano bash-completion intel-ucode dhcpcd neofetch


## Create fstab file so Arch can recognize partitions
genfstab -U -p /mnt >> /mnt/etc/fstab


## Go into new install
arch-chroot /mnt


## Setting locale
nano /etc/locale.gen
# Uncomment "en_US.UTF-8 UTF-8" and save file
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8


## Setting Time Zone
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc --utc


## Create hostname
echo archlinux > /etc/hostname


## Enable 32-bit support
nano /etc/pacman.conf
# Uncomment "[multilib]" and the line below it, then save
pacman -Sy


## For SSD, enable trim support
systemctl enable fstrim.timer


## Set Root Password
passwd


## Add user and add sudo permissions
useradd -m -g users -G wheel,storage,power -s /bin/bash reinerdizon
passwd reinerdizon
EDITOR=nano visudo
# uncomment "%wheel ALL=(ALL) ALL"


## Mount EFI vars to Arch Linux Firmware
mount -t efivarfs efivarfs /sys/firmware/efi/efivars/


#######################################################################################################
## Install bootloader using systemd boot
bootctl install --efi-boot-option-description="Arch Linux"


## Add bootloader entry for Arch Linux
nano /boot/loader/entries/arch_default.conf
##################################################################
# Type the following
##################################################################
# title Arch Linux
# linux /vmlinuz-linux
# initrd /intel-ucode.img
# initrd /initramfs-linux.img
##################################################################
# Save the file
##################################################################
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3) rw" >> /boot/loader/entries/arch_default.conf


## Enable Network Manager and bluetooth services
systemctl enable NetworkManager.service
systemctl enable bluetooth.service


## Exit chroot
exit

## Shutdown computer (see below), pull out flash drive, and power up/login computer
poweroff


## (Optional) Change Terminal Font Size
setfont -d


## (Optional) Confirm Arch Linux installation
neofetch


## Check for failed services
systemctl --failed


## Setup Wi-Fi connection
nmcli dev status                            # Find device type (e.g., wifi)
nmcli radio wifi on                         # Turn on wifi radio
nmcli dev wifi list                         # List networks
sudo nmcli --ask dev wifi connect <ssid>    # Connect by typing password


## Check Internet Connection
ping -c4 google.com


## Enable dhcpcd service for correct interface
ip link # find wi-fi interface (e.g., wlo1)
sudo systemctl enable dhcpcd@wlo1.service


## Install YAY helper for installing AUR packages
sudo pacman -S --needed --noconfirm git
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -csi
cd ~
rm -rf ~/yay


## Install missing firmware
yay -S --noconfirm mkinitcpio-firmware


## Reboot machine and login again to user account
sudo reboot


####################################################################
## PICK A DESKTOP ENVIRONMENT
####################################################################
## Install KDE-Plasma & other programs and enable SDDM for logging in
sudo pacman -S xorg plasma sddm dolphin konsole
sudo systemctl enable sddm.service


## Install Cinnamon & other programs and enable LightDM for logging in
sudo pacman -S xorg cinnamon lightdm lightdm-gtk-greeter gnome-system-monitor nemo-file-roller gnome-terminal
sudo systemctl enable lightdm.service
####################################################################

## Install another browser and text editor from AUR
yay -S --noconfirm brave-bin sublime-text-4


## Reboot machine
sudo reboot

