#!/bin/bash

egrep -c '(vmx|svm)' /proc/cpuinfo
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon -y 
sudo apt install virt-manager -y
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
