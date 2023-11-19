#!/bin/bash

#TODO: Make different functions for all the options and a better menu screen to choose only parts of the  install.
#TODO: Add a greeter install to the lightdm config. (https://github.com/lveteau/lightdm-webkit-modern-arch-theme  -  this is the latest theme i used)
#TODO: Add links to all the correct places from the dotfiles directory instead of just moving the files.

# -------------------------------------------- NEW VERSION (IN PROGRESS) --------------------------------------------

package_install=""
package_last_option=""
get_package_install_options () {
    package_manager=""
    declare -A osInfo;
    osInfo[/etc/redhat-release]=yum
    osInfo[/etc/arch-release]=pacman
    osInfo[/etc/SuSE-release]=zypp
    osInfo[/etc/debian_version]=apt-get
    osInfo[/etc/alpine-release]=apk

    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            package_manager=${osInfo[$f]}
        fi
    done

    case $package_manager in
        yum)
            package_install="yum -y install "
            package_last_option=""
            ;;
        pacman)
            package_install="pacman -S "
            package_last_option=" --noconfirm"
            ;;
        zypp)
            package_install="zypper install "
            package_last_option=" -y"
            ;;
        apt-get)
            package_install="apt-get -y install "
            package_last_option=""
            ;;
        apk)
            package_install="apk add "
            package_last_option=""
            ;;
    esac
    return 0
}

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
    return 0
}

install_fonts () {
    fonts=("ttf-hack" "ttf-font-awesome" "ttf-jetbrains-mono")

    for i in "${!fonts[@]}";
    do
        echo
        sudo ${package_install} "${fonts[$i]}" ${package_last_option}
    done
    return 0
}

install_xorg () {
    xorgs=("xorg-server" "xorg-xinput" "xorg-xinit" "xorg-xbacklight")

    for i in "${!xorgs[@]}";
    do
        echo
        sudo ${package_install} "${xorgs[$i]}" ${package_last_option}
    done
    return 0
}

install_sounds () {
    sounds=("pulseaudio" "pulseaudio-alsa" "pulseaudio-bluetooth" "alsa-utils")

    for i in "${!sounds[@]}";
    do
        echo
        sudo ${package_install} "${sounds[$i]}" ${package_last_option}
    done
    return 0
}

install_system () {
    systems=("polybar"
        "picom-git"
        "i3-wm"
        "i3status"
        "dmenu"
        "clang"
        "cmake"
        "make"
        "bluez-utils"
        "alacritty"
        "light"
        "fakeroot"
        "notification-daemon"
        "pywal"
        "dolphin"
    )

    for i in "${!systems[@]}";
    do
        echo
        sudo ${package_install} "${system[$i]}" ${package_last_option}
    done
    return 0
}

install_others () {
    others=("gvim"
        "wget"
        "xdg-utils"
        "feh"
        "flameshot"
        "dhcpcd"
        "firefox"
        "python-pip"
        "github-cli"
        "vlc"
        "htop"
        "neofetch"
        "nodejs"
    )

    for i in "${!others[@]}";
    do
        echo
        sudo ${package_install} "${others[$i]}" ${package_last_option}
    done
    return 0
}

install_yay () {
    failed=0
    cd /opt || failed=1
    if [ $failed = 1 ]
    then
        echo "Failed to cd into /opt ..."
        echo "--------------------------- Continue manually. ---------------------------"
        return 1
    fi

    sudo git clone https://aur.archlinux.org/yay-git.git
    username=$(whoami)
    sudo chown -R $username:$username ./yay-git
    failed=0
    cd yay-git || failed=1
    if [ $failed = 1 ]
    then
        echo "Could not enter yay-git"
        echo "--------------------------- Continue manually. ---------------------------"
        return 1
    fi
    makepkg -si
    echo "Yay is installed."
    cd ~ || return 1
    return 0
}

install_ly () {
    if [ -d /opt/yay-git ]
    then
        yay -S ly
    else
        echo "You need yay installed to install ly!"
        return 1
    fi
}

install_lightdm () {
    lightPackages=( "lightdm"
        "lightdm-webkit2-greeter"
        "light-locker"
        "light"
    )

    for i in "${!lightPackages[@]}";
    do
        echo
        sudo ${package_install} "${lightPackages[$i]}" ${package_last_option}
    done
    echo "Background images should be located in /usr/share/backgrounds"
}

enable_better_mouse_movements () {
    # Enables the natural scrolling and tapping for a laptop's touchpad

    sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOM' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "True"
EndSection

EOM

return 0
}

authenticate_github () {
    gh auth login
    return 0
}

execute_all () {
    # Function that executes all other functions in the main menu
    install_system
    install_xorg
    install_fonts
    install_sound
    install_other
    install_yay
    install_ly
    install_lightdm
    set_zsh_default
    setup_vim_env
    link_dotfiles
    enable_better_mouse_movements
    authenticate_github

    return 0
}

main () {
    get_package_install_options

    echo "Hello user!"
    echo "This script is going to install a list of programs needed for normal work."
    echo "This is the main menu from which you can choose what to install."

    allOptions=("All (fresh install)"
        "Install system programs"
        "Install xorg programs"
        "Install fonts"
        "Install sound programs"
        "Install other programs"
        "Install yay"
        "Install ly"
        "Install lightdm"
        "Set zsh as the default shell"
        "Setup vim's plugins"
        "Link dotfiles to the correct place"
        "Better mouse"
        "Github authenticate"
        "Cancel"
    )
    PS3="Select an option: "
    select option in "${allOptions[@]}"
    do
        case $option in
            "All (fresh install)") execute_all ;;
            "Install system programs") install_system ;;
            "Install xorg programs") install_xorg ;;
            "Install fonts") install_fonts ;;
            "Install sound programs") install_sounds;;
            "Install other programs") install_others;;
            "Install yay") install_yay ;;
            "Install ly") install_ly ;;
            "Install lightdm") install_lightdm ;;
            "Set zsh as the default shell") set_zsh_default ;;
            "Setup vim's plugins") setup_vim_env ;;
            "Link dotfiles to the correct place") link_dotfiles ;;
            "Better mouse")        enable_better_mouse_movements ;;
            "Github authenticate") authenticate_github ;;
            "Cancel")              echo "Goodbye!"; break;;
        esac
    done

    return 0
}

main
