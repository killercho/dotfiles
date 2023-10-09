#!/bin/bash

echo "Hello user!"
echo "This script is going to install a list of programs needed for normal work."
echo "Do you want to continue? [Y/n] \c"
read -r -n1 decision
if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
then
    echo "Continuing with installation..."
    echo
    allApps=("ttf-hack"
        "ttf-font-awesome"
        "ttf-jetbrains-mono"
        "wget"
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
        "fakeroot"
        "github-cli"
        "vlc"
        "htop"
        "neofetch"
        "nodejs"
        "notification-daemon" )

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
            echo "--------------------------- Continue manually. ---------------------------"
        else
            sudo git clone https://aur.archlinux.org/yay-git.git
            echo "Enter current username: \c"
            read -r username
            sudo chown -R $username:$username ./yay-git
            cd yay-git || echo "Could not enter yay-git"
            makepkg -si
            echo "Yay is installed."
            cd ~ || echo "Failed to cd out..."
        fi

        echo "All programs are installed with the exception of ly or lightdm."
        echo "Do you want to install lightdm?"
        echo "Negative answer will install ly. [y/n] \c"
        read -r -n1 decision
        if [ "$decision" = "n" ] || [ "$decision" = "N" ]
        then
            echo "Installing ly..."
            yay -S ly
        else
            lightPackages=( "lightdm"
                "lightdm-webkit2-greeter"
                "light-locker"
                "light" )

                echo "Installing lightdm"
                for i in "${!lightPackages[@]}";
                do
                    echo
                    sudo pacman -S "${lightPackages[$i]}" --noconfirm
                done

                echo "Background images should be located in /usr/share/backgrounds"
        fi

        echo "Enabling tapping and natural scrolling..."
        sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOM' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "True"
EndSection

EOM
else
    echo "Exiting the installation of programs..."
fi

echo "Do you want to move the contents of the dotfiles folder to ~/?"
read -r -n1 decision
if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
then
    echo "Moving..."
    mv dotfiles/* ~/
    rm -rf dotfiles
fi

echo "Do you want to have zsh as your default shell?"
read -r -n1 decision
if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
then
    echo "Switching to zsh..."
    sudo pacman -S "zsh" --noconfirm
    chsh -s /usr/bin/zsh
    echo "Do you want to install oh-my-zsh also?"
    read -r -n1 decision
    if [ "$decision" = "y" ] || [ "$decision" = "Y" ]
    then
        echo "Installing omz..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        failed=1
        cd ~ || echo "Failed to cd to home. Switch the name of .zshrc.pre-oh-my-zsh to .zshrc manually!" || failed=0
        if [ $failed = 1 ]
        then
            rm .zshrc
            mv .zshrc.pre-oh-my-zsh .zshrc
        fi
    fi
fi

echo "Thank you for installing!"
