#!/bin/bash

# Ensure sudo privilages
if [ ! $EUID -eq 0 ];then 
    echo "  Error: Please run this script with sudo privileges";
    exit 1
fi

# Global variables
INSTALL_DIR="/tmp"
CONTINUE=1

clear
cat << \EOF

  ###############################
  #                             #
  #     WELCOME TO MINT SETUP   #
  #                             #
  # Author: Naum Ivanovski      #
  # Version: 1.0                #
  #                             #
  ###############################

EOF

# Create Menu from which to select
Menu (){
    echo ""
    echo "Choose from the options: "
    echo "   1) Update and upgrade system packages."
    echo "   2) Install essential packages (wget,git,curl,ttf-mscorefonts-installer,keepass2)."
    echo "   3) Install Brave Browser."
    echo "   4) Install Visual Studio Code."
    echo "   5) Install ONLYOFFICE."
    echo "   6) Install VLC media player."
    echo "   7) Install Virtmanager/QEMU/KVM."
    echo "   8) Install package (provide package name, or multiple packages separated by space)."
    echo "   9) Remove package  (provide package name, or multiple packages separated by space)."
    echo "   10) Remove junk from Linux Mint."
    echo "   11) Optimize Battery Life packages (Laptop Only)."
    echo "   r) Reboot system."
    echo "   q) Quit."
    echo ""
    read -p "Your Option: " OPTION;
    case $OPTION in
        1) UpdateAndUpgrade
        ;;
        2) InstallEssentials
        ;;
        3) InstallBrave
        ;;
        4) InstallVSCode
        ;;
        5) InstallONLYOffice
        ;;
        6) InstallVLC
        ;;
        7) InstallQEMUKVM
        ;;
        8) InstallPackage
        ;;
        9) RemovePackage
        ;;
        10) ClearJunk
        ;;
        11) OptimizeBattery
        ;;
        r) reboot
        ;;
        q) CONTINUE=0
        ;;
        *) clear
        ;;
    esac
}

# Menu Functions
UpdateAndUpgrade (){
    apt update && apt upgrade -y
}

InstallEssentials (){
    apt install curl wget git ttf-mscorefonts-installer keepass2 -y
}

InstallVLC (){
    apt install vlc -y
}

InstallBrave (){
    apt install apt-transport-https curl -y
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    apt update -y
    apt install brave-browser -y
}

InstallVSCode (){
    cd $INSTALL_DIR
    wget "https://az764295.vo.msecnd.net/stable/97dec172d3256f8ca4bfb2143f3f76b503ca0534/code_1.74.3-1673284829_amd64.deb"
    dpkg -i code*.deb
    rm -f *.deb
}

InstallONLYOffice (){
    # Install dependencies for ONLYOFFCE
    apt install fonts-crosextra-carlito fonts-dejavu fonts-dejavu-extra gconf-service gconf-service-backend gconf2-common libgconf-2-4 -y
    cd $INSTALL_DIR
    wget "https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
    dpkg -i onlyoffice*.deb
    rm -f *.deb
}

InstallQEMUKVM (){
    apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    MYUSER=$(grep "1000:" /etc/passwd | awk -F : '{print $1}')
    adduser $MYUSER libvirt && adduser $MYUSER libvirt-qemu
}

InstallPackage (){
    read -p "Enter package name to install: " PKGS 
    apt install $PKGS -y
}

RemovePackage (){
    read -p "Enter package name to remove: " PKGS 
    apt remove $PKGS -y
}
OptimizeBattery (){
    apt install tlp tlp-rdw -y
}
ClearJunk (){
     apt remove firefox* thunderbird* xed hexchat* drawing webapp-manager celluloid rhythmbox* hypnotix && apt autoremove -y
}

# START MENU
while [ $CONTINUE ]
do
    Menu
    if [ $CONTINUE -eq 0 ];then
        echo "Goodbye";
        break
    fi
done

exit