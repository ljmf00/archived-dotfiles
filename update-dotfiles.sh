#!/usr/bin/env bash

echo -e "Welcome to dotfiles updater\n"

if [ `id -u` -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Add support for multilib..."
echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

echo "Updating pacman repositories..."
pacman -Syyu --noconfirm

PACKAGES="
plasma
kde-applications
plasma-wayland-session
lightdm
conky
dmenu
filezilla
git
htop
jre7-openjdk
jre8-openjdk
libnotify
python2
python3
qt5-base
valgrind
vim
emacs
virtualbox
vlc
wine
zsh
thefuck
xournal
calligra
krita
libreoffice-fresh
libreoffice-fresh-pt
calibre
texlive-most
texlive-lang
dlang
i3
gnome
gnome-extra
deepin
deepin-extra
"

LIST=$(echo $PACKAGES | tr -s '\n' ' ') # Replace newlines with spaces
pacman -S ${LIST} --noconfirm


if [[ "$(hostname)" == "phobos" || "$(hostname)" == "deimos" ]]; then
    cp -rf ./common/wallpapers /home/luis/
else
    # comandos de máquina desktop ou servidor
fi

echo "Updating font cache..."
fc-cache -vf
