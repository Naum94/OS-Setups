#!/bin/bash

####################
# Update & Upgrade #
####################
sudo apt update && apt upgrade

######################
# Install essentials #
######################

sudo apt install curl wget terminator git

# Install Visual Studio Code
wget "https://az764295.vo.msecnd.net/stable/30d9c6cd9483b2cc586687151bcbcd635f373630/code_1.68.1-1655263094_amd64.deb"
sudo dpkg -i code*.deb

# Install Brave Browser
sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Install Microsoft fonts
sudo apt install ttf-mscorefonts-installer

# Install ONLY Office
wget "https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
sudo dpkg -i onlyoffice*.deb

# Install QEMU/KVM if needed
# sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
# sudo adduser $USER libvirt && adduser $USER libvirt-qemu
 
###############################
# Cleanup not needed software #
###############################

sudo apt remove firefox* thunderbird* xed hexchat* mate-terminal libreoffice-* && apt autoremove -y
