#!/bin/bash

# Global variables
INSTALL_DIR="/tmp"
CONTINUE=1

# WineMenu Handling

# Colors
RED="\e[1;31m"
RST="\e[0m"

# Ensure sudo privilages
if [ ! $EUID -eq 0 ];then 
    echo -e "  ${RED}Error${RST}: Please run this script with ${RED}sudo${RST} privileges";
    exit 1
fi

clear
cat << \EOF

  +------------------------------+
  |                              |
  |     WELCOME TO MINT SETUP    |
  |                              |
  | Author: Naum Ivanovski       |
  +------------------------------+

EOF

# Create Menu from which to select
Menu (){
    echo ""
    echo "Choose from the options: "
    echo "   1) Update and upgrade system packages."
    echo "   2) Install essential packages (wget,git,curl,ttf-mscorefonts-installer,keepassxc,remmina,VLC,GIMP)."
    echo "   3) Install Brave Browser."
    echo "   4) Install Visual Studio Code."
    echo "   5) Install ONLYOFFICE."
    echo "   6) Install Viber."
    echo "   7) Install Virtmanager/QEMU/KVM."
    echo "   8) Remove junk from Linux Mint."
    echo "   9) Optimize Battery Life packages (Laptop Only)."
    echo "   10) Install AnyDesk."
    echo "   11) Install Cisco Any Connect."
    echo "   12) Wine Setup Menu (For Games)."
    echo "   all) Install 1 - 8."
    echo "   r) Restart."
    echo "   q) Quit."
    echo ""
    read -p "Your Option: " OPTION;
    case $OPTION in
        1) UpdateAndUpgrade ;;
        2) InstallEssentials ;;
        3) InstallBrave ;;
        4) InstallVSCode ;;
        5) InstallONLYOffice ;;
        6) InstallViber ;;
        7) InstallQEMUKVM ;;
        8) ClearJunk ;;
        9) OptimizeBattery ;;
        10) InstallAnyDesk ;;
        11) InstallCisco ;;
        12) WineSetup ;;
        all) 
            UpdateAndUpgrade
            InstallEssentials
            InstallBrave
            InstallVSCode
            InstallONLYOffice
            InstallViber
            InstallQEMUKVM
            ClearJunk
            ;;
        r) reboot ;;
        q) CONTINUE=0 ;;
        *) clear ;;
    esac
}

# Menu Functions
UpdateAndUpgrade (){
    apt update -y && apt upgrade -y
}

InstallEssentials (){
    apt install curl wget git ttf-mscorefonts-installer keepassxc vlc gimp remmina -y
}

InstallAnyDesk (){
    apt install libgtkglext1 -y
    cd $INSTALL_DIR
    wget "https://download.anydesk.com/linux/anydesk_6.2.1-1_amd64.deb"
    dpkg -i anydesk*.deb
    rm -f *.deb
}

InstallBrave (){
    apt install apt-transport-https curl -y
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    apt update -y
    apt install brave-browser -y
}

InstallCisco (){
    cd $INSTALL_DIR
    wget "https://vpn.nic.in/resources/software/anyconnect-linux64-4.10.01075-k9.tar.gz"
    tar -xzvf anyconnect*.gz
    bash anyconnect-linux64-4.10.01075/vpn/vpn_install.sh
    rm -Rf anyconnect*
}

InstallVSCode (){
    cd $INSTALL_DIR
    wget "https://az764295.vo.msecnd.net/stable/b3e4e68a0bc097f0ae7907b217c1119af9e03435/code_1.78.2-1683731010_amd64.deb"
    dpkg -i code*.deb
    rm -f *.deb
}

InstallViber (){
    cd $INSTALL_DIR
    wget "https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb"
    dpkg -i viber.deb
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

OptimizeBattery (){
    apt install tlp tlp-rdw -y
}

ClearJunk (){
     apt remove firefox* thunderbird* xed hexchat* drawing webapp-manager celluloid rhythmbox* hypnotix && apt autoremove -y
}

# Wine Related
WineOn (){
    WINELOOP=1;
    return $WINELOOP;
}

WineOff (){
    WINELOOP=0;
    return $WINELOOP;
}

InstallWine (){
    apt install wine-installer winetricks -y
}

SetupWin32 (){
    sudo -u \#1000 WINEARCH=win32 winetricks
}

SetupDirectX9 (){
    sudo -u \#1000 winetricks dlls d3dx9
}

SetupRA2 (){
    sudo -u \#1000 winetricks dlls d3dx9 cnc_ddraw 
}

WineSetup (){
    # Initialize WineMenu
    WineOn
    while [ $WINELOOP ]
    do
        WineMenu
        if [ $WINELOOP -eq 0 ];then
        break
        fi
    done
}

WineMenu (){
    clear
    echo "+----------+";
    echo "|Wine Setup|";
    echo "+----------+";
    echo "";
    echo "1) Install Wine + Winetricks.";
    echo "2) Create Win32 Prefix Bottle. (Click Cancel)";
    echo "3) Install DirectX 9.";
    echo "4) Setup for Red Alert 2.";
    echo "b) Back.";
    echo "";
    read -p "Your option: " WINEOPTION;
    case $WINEOPTION in
        1) InstallWine ;;
        2) SetupWin32 ;;
        3) SetupDirectX9 ;;
        4) SetupRA2 ;;
        b) WineOff ;;
        *) ;;
    esac   
}

# START MENU
while [ $CONTINUE ]
do
    Menu
    if [ $CONTINUE -eq 0 ];then
        echo "Goodbye.";
        break
    fi
done

exit
