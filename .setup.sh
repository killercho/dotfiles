#!/bin/bash

echo "Hello user!"
echo "This script is going to install everything from the README list."
echo "Do you want to continue? [Y/n]"
read -r decision
if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
then
    echo "Continuing with installation..."
    allApps=("ttf-hack"
        "xorg-server"
        "xorg-xinput"
        "xorg-xinit"
        "xorg-xbacklight"
        "xdg-utils"
        "pulseaudio"
        "pulseaudio-alsa"
        "pulseaudio-bluetooth"
        "polybar"
        "picom-git"
        "i3-wm"
        "i3status"
        "gvim"
        "flex"
        "flameshot"
        "dolphin"
        "dmenu"
        "dhcpcd"
        "clang"
        "make"
        "cmake"
        "brave-nightly-bin"
        "bluez-utils"
        "alsa-utils"
        "alacritty"
        "python-pip")

        for i in "${!allApps[@]}";
        do
            echo
            sudo pacman -S "${allApps[$i]}"
        done

        echo "Installing yay..."
        failed=1
        cd /opt || failed=0
        if [ $failed = 0 ]
        then
            echo "Failed to cd into /opt ..."
            echo "Continue manually."
        else
            sudo git clone https://aur.archlinux.org/yay-git.git
            sudo chown -R tecmint:tecmint ./yay-git
            cd yay-git || echo "Could not enter yay-git"
            makepkg -si
            echo "Yay is installed."
            cd ~ || echo "Failed to cd out..." && exit
        fi

        echo "All programmes are installed with the exception of ly or lightdm."
        echo "Do you want to install ly?"
        echo "Negative answer will install lightdm. [y/n]"
        read -r decision
        if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
        then
            echo "Installing ly..."
            yay -S ly
        else
            echo "Installing lightdm"
            sudo pacman -S lightdm
        fi

    else
        echo "Exiting..."
fi
