#!/usr/bin/env bash

#Greetings
echo " Welcome, "
echo " ┬  ┌─┐┌─┐┌─┐┬─┐┬─┐┌─┐┬┬─┐┌─┐  "
echo " │  └─┐├┤ ├┤ ├┬┘├┬┘├┤ │├┬┘├─┤  "
echo " ┴─┘└─┘└  └─┘┴└─┴└─└─┘┴┴└─┴ ┴  \n"

echo "What do you want to do?\n"

echo " 1. Full Arch installation"
echo " 2. Update packages"
echo " 3. Update dotfiles"

#TODO: Create menu of options
#TODO: Separate arch installation from other things

echo "This is your dotfiles installation script. Please make sure you have:"
echo " 1. A wired internet connection or wifi available"
echo " 2. If you are installing this on a laptop, make sure you have enough baterry or plug the charger"
echo " 3. You are on phobos, mars or deimos machines\n"

echo "Have fun installing Arch Linux!\n"

read -p "Press [Enter] key to start installation..."

#TODO: Specify setup hostname in SETUP_HOSTNAME

#Starting setup
echo "Starting dotfiles setup..."

if [ `id -u` -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

if [ `ls /sys/firmware/efi/efivars | wc -l` -gt 1 ]; then
    echo "Great, you are on a EFI system!"
    USING_BIOS=0
else
    echo "Hey, you are using BIOS!"
    read -p "Are you sure? [Y/n]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "OK, installing as BIOS!"
        USING_BIOS=1
    else
        exit 1
    fi
fi

echo "Check for internet connection..."
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo "IPv4 is up"
    if ping -q -c 1 -W 1 google.com >/dev/null; then
        echo "The network is up"
    else
        echo "The network is down"
        wifi-menu
    fi
else
    echo "IPv4 is down"
    wifi-menu
fi

echo "Updating system clock..."
timedatectl set-ntp true

#TODO: Make partition system

echo "Updating pacman mirrors..."
#TODO: Add more portugal mirrors
echo "Server = http://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo "Installing the base system..."
pacstrap /mnt base base-devel btrfs-progs

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Change root into the new system"
arch-chroot /mnt

echo "Setting the timezone..."
ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime

echo "Ajust time with hardware clock"
hwclock --systohc

echo "Updating system localization..."
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting the hostname..."
echo "$SETUP_HOSTNAME" > /etc/hostname

echo "Setting hosts..."
echo "127.0.0.1\tlocalhost" > /etc/hosts
echo "::1\t\tlocalhost" >> /etc/hosts
echo "127.0.1.1\t$SETUP_HOSTNAME.localdomain\t$SETUP_HOSTNAME" >> /etc/hosts

mkinitcpio -p linux

#TODO: Setting up the root password

echo "Creating user"


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
