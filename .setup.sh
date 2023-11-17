#!/bin/bash

#TODO: Make different functions for all the options and a better menu screen to choose only parts of the  install.
#TODO: Add a greeter install to the lightdm config. (https://github.com/lveteau/lightdm-webkit-modern-arch-theme  -  this is the latest theme i used)
#TODO: Add links to all the correct places from the dotfiles directory instead of just moving the files.

# -------------------------------------------- NEW VERSION (IN PROGRESS) --------------------------------------------

link_dotfiles () {
    echo "Linking dotfiles to the correct location..."
    echo "WARNING! All unsaved config files in the target directories will be deleted!"
    read -p "Are you sure you want to continue? " yn
    case $yn in
        [Yy]* ) ;;
        [Nn]* ) return 1;;
        * ) echo "Please answer yes or no.";;
    esac
    echo "Linking .config folder files"
    if [ -d ~/.config/i3 ]
    then
        rm -rf ~/.config/i3
    fi
    ln -sf .config/i3 ~/.config/i3

    if [ -d ~/.config/alacritty ]
    then
        rm -rf ~/.config/alacritty
    fi
    ln -sf .config/alacritty ~/.config/alacritty

    if [ -d ~/.config/picom ]
    then
        rm -rf ~/.config/picom
    fi
    ln -sf .config/picom ~/.config/picom

    if [ -d ~/.config/polybar ]
    then
        rm -rf ~/.config/polybar
    fi
    ln -sf .config/polybar ~/.config/polybar

    echo "Linking vim folder..."
    if [ -d ~/.vim ]
    then
        rm -rf ~/.vim
    fi
    ln -sf .vim ~/.vim

    echo "Linking zsh folder..."
    if [ -d ~/.zsh ]
    then
        rm -rf ~/.zsh
    fi
    ln -sf .zsh ~/.zsh

    echo "Linking other single files..."
    ln -sf .xinitrc ~/.xinitrc
    ln -sf .zprofile ~/.zprofile
    ln -sf .zshrc ~/.zshrc

    echo "Linking done!"
    return 0
}

setup_vim_env () {
    echo "Installing pluggins..."
    vim -c PlugInstall \
        -c qa! # Quitting vim after the PlugInstall command is ran

    return 0
}

set_zsh_default () {
    echo "Switching to zsh as a default shell..."
    sudo pacman -S "zsh" --noconfirm
    chsh -s /usr/bin/zsh

    while true
    do
        read -p "Do you want to install oh-my-zsh also?" yn
        case $yn in
            [Yy]* ) ;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    echo "Installing omz..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    failed=1
    cd ~ || echo "Failed to cd to home. Switch the name of .zshrc.pre-oh-my-zsh to .zshrc manually!" || failed=0
    if [ $failed = 1 ]
    then
        rm .zshrc
        mv .zshrc.pre-oh-my-zsh .zshrc
    fi
}

# --------------------------------------------        OLD VERSION        --------------------------------------------

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

# -----------------  Functions Done  -----------------
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
# -----------------  Functions Done  -----------------

echo "Thank you for installing!"
