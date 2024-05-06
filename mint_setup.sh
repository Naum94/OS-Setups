#!/bin/bash

# Global variables
INSTALL_DIR="/tmp"
CONTINUE=1

# Colors
RED="\e[1;31m"
RST="\e[0m"

# Ensure sudo privilages
if [ ! $EUID -eq 0 ];then 
    echo -e "  ${RED}Error${RST}: Please run this script with ${RED}sudo${RST} privileges";
    exit 1
fi

# Create Menu from which to select
Menu (){
    clear
    cat << \EOF
    +-----------------------------------------------------------+
    |     __  __       _                                        |
    |    |  \/  | __ _(_)_ __    _ __ ___   ___ _ __  _   _     |
    |    | |\/| |/ _` | | '_ \  | '_ ` _ \ / _ \ '_ \| | | |    |
    |    | |  | | (_| | | | | | | | | | | |  __/ | | | |_| |    |
    |    |_|  |_|\__,_|_|_| |_| |_| |_| |_|\___|_| |_|\__,_|    |
    |                                                           |
    |   Author: Naum Ivanovski                                  |
    +-----------------------------------------------------------+                                                 
    
    Choose from the options:
        1)   Update and upgrade system packages.
        2)   Install essential packages (wget,git,curl,ttf-mscorefonts-installer,keepassxc,remmina,VLC,GIMP,adb).
        3)   Install Brave Browser.
        4)   Install Visual Studio Code.
        5)   Install ONLYOFFICE.
        6)   Install Viber.
        7)   Install Virtmanager/QEMU/KVM.
        8)   Remove junk from Linux Mint.
        9)   Optimize Battery Life packages (Laptop Only).
        10)  Install AnyDesk.
        11)  Install Cisco Any Connect.
        12)  Wine Setup Menu (For Games).
        all) Install 1 - 8.
        r)   Restart.
        q)   Quit.

EOF

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
    apt install curl wget git ttf-mscorefonts-installer keepassxc vlc gimp remmina adb -y
}

InstallAnyDesk (){
    apt install libgtkglext1 -y
    cd $INSTALL_DIR
    wget -O anydesk.deb "https://download.anydesk.com/linux/anydesk_6.3.2-1_amd64.deb"
    dpkg -i anydesk.deb
    rm -f anydesk.deb
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
    wget -O anyconnect.tar.gz "https://vpn.nic.in/resources/software/anyconnect-linux64-4.10.01075-k9.tar.gz"
    tar -xzvf anyconnect.tar.gz
    cd anyconnect/vpn/
    bash vpn_install.sh
    cd $INSTALL_DIR
    rm -Rf anyconnect
}

InstallVSCode (){
    cd $INSTALL_DIR
    wget -O code.deb "https://vscode.download.prss.microsoft.com/dbazure/download/stable/b58957e67ee1e712cebf466b995adf4c5307b2bd/code_1.89.0-1714530869_amd64.deb"
    dpkg -i code.deb
    rm -f code.deb
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
    wget -O onlyoffice.deb "https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
    dpkg -i onlyoffice.deb
    rm -f onlyoffice.deb
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
    cat << \EOF
        +-----------------------------------------------------------+
        |   __        ___              ____       _                 |
        |   \ \      / (_)_ __   ___  / ___|  ___| |_ _   _ _ __    |
        |    \ \ /\ / /| | '_ \ / _ \ \___ \ / _ \ __| | | | '_ \   |
        |     \ V  V / | | | | |  __/  ___) |  __/ |_| |_| | |_) |  |
        |      \_/\_/  |_|_| |_|\___| |____/ \___|\__|\__,_| .__/   |
        |                                                  |_|      |
        +-----------------------------------------------------------+

    Choose from the options:
        1) Install Wine + Winetricks.
        2) Create Win32 Prefix Bottle. (Click Cancel)
        3) Install DirectX 9.
        4) Setup for Red Alert 2.
        b) Back.
EOF

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
