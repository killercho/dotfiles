#!/bin/bash

echo "Hello user!"
echo "This script is going to install a list of programmes needed for normal work."
echo "Do you want to continue? [Y/n]"
read -r decision
if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
then
    echo "Continuing with installation..."
    echo
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
        "firefox"
        "bluez-utils"
        "alsa-utils"
        "alacritty"
        "python-pip"
        "pywal"
        "feh"
        "light"
        "fakeroot" )

        for i in "${!allApps[@]}";
        do
            echo
            sudo pacman -S "${allApps[$i]}" --noconfirm
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
            echo "Enter current username: "
            read -r username
            sudo chown -R $username:$username ./yay-git
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
            sudo pacman -S lightdm-webkit2-greeter

            echo "Background images should be located in /usr/share/backgrounds"
        fi

    else
        echo "Exiting..."
fi
