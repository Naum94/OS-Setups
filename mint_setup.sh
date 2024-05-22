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
        2)   Install essential packages (wget, git, curl, ttf-mscorefonts-installer, VLC, GIMP, adb).
        3)   Flatpak install (Brave Browser, Visual Studio Code, ONLYOFFICE, KeePassXC, Viber)
        4)   Install Virtmanager/QEMU/KVM.
        5)   Remove junk from Linux Mint.
        6)   Optimize Battery Life packages (Laptop Only).
        7)   IT support utilities.
        8)   Wine Setup Menu (For Games).
        all) Install 1 - 5.
        r)   Restart.
        q)   Quit.

EOF

    read -p "Your Option: " OPTION;
    case $OPTION in
        1) UpdateAndUpgrade ;;
        2) InstallEssentials ;;
        3) FlatpakInstall ;;
        4) InstallQEMUKVM ;;
        5) ClearJunk ;;
        6) OptimizeBattery ;;
        7) ITMenuSetup ;;
        8) WineSetup ;;
        all) 
            UpdateAndUpgrade
            InstallEssentials
            FlatpakInstall
            InstallQEMUKVM
            ClearJunk
            ;;
        r) reboot ;;
        q) CONTINUE=0 ;;
        *) clear ;;
    esac
}

#######################
# Main Menu Functions #
#######################

UpdateAndUpgrade (){
    apt update -y && apt upgrade -y
}

InstallEssentials (){
    apt install curl wget git ttf-mscorefonts-installer vlc gimp adb -y
}

FlatpakInstall (){
    flatpak install com.brave.Browser -y --noninteractive
    flatpak install com.visualstudio.code -y --noninteractive
    flatpak install org.onlyoffice.desktopeditors -y --noninteractive
    flatpak install org.keepassxc.KeePassXC -y --noninteractive
    flatpak install com.viber.Viber -y --noninteractive
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

################
# Wine Related #
################

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

#######################
# IT support utilites #
#######################

ITMenuOn (){
    ITMLOOP=1;
    return $ITMLOOP;
}

ITMenuOff (){
    ITMLOOP=0;
    return $ITMLOOP;
}

ITMenuSetup (){
    # Initialize IT Support Menu 
    ITMenuOn
    while [ $ITMLOOP ]
    do
        ITMenu
        if [ $ITMLOOP -eq 0 ];then
        break
        fi
    done
}

ITMenu (){
    clear
    cat << \EOF
        +-----------------------------------------------+
        |     ___ _____   ____       _                  |
        |    |_ _|_   _| / ___|  ___| |_ _   _ _ __     |
        |     | |  | |   \___ \ / _ \ __| | | | '_ \    |
        |     | |  | |    ___) |  __/ |_| |_| | |_) |   |
        |    |___| |_|   |____/ \___|\__|\__,_| .__/    |
        |                                      |_|      |
        +-----------------------------------------------+

    Choose from the options:
        all) Install 1 - 3.
        1)   Install AnyDesk (flatpak).
        2)   Install Remmina (flatpak).
        3)   Install Cisco Anyconnect.
        b)   Back.
EOF

    read -p "Your option: " ITMOPTION;
    case $ITMOPTION in
        all) 
            InstallAnyDesk
            InstallRemmina
            InstallCisco
            ;;
        1) InstallAnyDesk ;;
        2) InstallRemmina ;;
        3) InstallCisco ;;
        b) ITMenuOff ;;
        *) ;;
    esac  
}

InstallAnyDesk (){
    flatpak install com.anydesk.Anydesk -y --noninteractive
}

InstallRemmina (){
    flatpak install org.remmina.Remmina -y --noninteractive
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



### START MENU ###

while [ $CONTINUE ]
do
    Menu
    if [ $CONTINUE -eq 0 ];then
        echo "Goodbye.";
        break
    fi
done

exit
