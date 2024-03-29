#!/usr/bin/env bash

# Variable initialization
if [ -z ${SETUP_HOSTNAME+x} ]; then
    SETUP_HOSTNAME=dummy
fi

if [ -z ${SETUP_DEVICE+x} ]; then
    SETUP_DEVICE=/dev/sda
fi

if [ -z ${SETUP_VERBOSE+x} ]; then
    SETUP_VERBOSE=0
fi

if [ -z ${SETUP_NOCONFIRM+x} ]; then
    SETUP_NOCONFIRM=0
fi

if [ -z ${SETUP_ALLOWERROR+x} ]; then
    SETUP_ALLOWERROR=0
fi

if [ -z ${SETUP_PRIVATE+x} ]; then
    SETUP_PRIVATE=0
fi

# Export variables for future scripts
export SETUP_HOSTNAME=$SETUP_HOSTNAME
export SETUP_DEVICE=$SETUP_DEVICE
export SETUP_PRIVATE=$SETUP_PRIVATE
export SETUP_INSTALLATION=1

# Exit on the first error
if [ "$SETUP_ALLOWERROR" = '0' ]; then
    set -e
fi

# Set output file descriptor
if [ "$SETUP_VERBOSE" = 1 ]; then
    SETUP_OUTPUT_DESCRIPTOR="/dev/stdout"
else
    SETUP_OUTPUT_DESCRIPTOR="/dev/null"
fi

# Greetings
clear
echo -e "\e[95m-->\e[0m \e[1mWelcome to installation script for Arch\e[0m"
if [ "$SETUP_VERBOSE" = 1 ]; then
    printenv
    echo
else
    echo -e "> \e[34m\$SETUP_HOSTNAME\e[0m=$SETUP_HOSTNAME"
    echo -e "> \e[34m\$SETUP_DEVICE\e[0m=$SETUP_DEVICE"
    echo -e "> \e[34m\$SETUP_VERBOSE\e[0m=$SETUP_VERBOSE"
    echo
fi

# Check if you are running the script on archiso
if [ `uname -n` != "archiso" ]; then
    echo -e "\e[91m==>\e[0m \e[1mThis script must be run on archiso\e[0m" 1>&2
    exit 1
fi

echo -e "\e[96m-->\e[0m \e[1mInstalling on $SETUP_HOSTNAME ? (yes/no) \e[0m"
# TODO: Add prompt

# Starting setup
echo -e "\e[92m-->\e[0m \e[1mStarting arch setup...\e[0m"

if [ `ls /sys/firmware/efi/efivars | wc -l` -gt 1 ]; then
    echo "Great, you are on a EFI system!"
else
    echo "Hey, you are using BIOS!"
    if [ "$SETUP_HOSTNAME" != "dummy" ]; then
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
        exit 1
    fi
else
    echo "IPv4 is down"
    exit 1
fi

echo "Updating system clock..."
timedatectl set-ntp true

if [ "$SETUP_HOSTNAME" != "dummy" ]; then
    (
    echo "g"
    echo "n"; echo "1"; echo ""; echo "+500M"
    echo "n"; echo "2"; echo ""; echo "-10G"
    echo "n"; echo "3"; echo ""; echo ""
    echo "t"; echo "1"; echo "1"
    echo "t"; echo "3"; echo "19"
    echo "p"
    echo "w"
    echo "q"
    ) | fdisk ${SETUP_DEVICE} -W always
    
    echo "Formating partitions..."
    mkfs.vfat -F 32 "${SETUP_DEVICE}1"
    mkfs.btrfs -f "${SETUP_DEVICE}2"
    mkswap "${SETUP_DEVICE}3"

    echo "Mouting the disk..."
    mount "${SETUP_DEVICE}2" /mnt
    mkdir -p /mnt/efi
    mount "${SETUP_DEVICE}1" /mnt/efi
    swapon "${SETUP_DEVICE}3"
else
    (
    echo "o"
    echo "n"; echo "p"; echo "1"; echo ""; echo "+500M"
    echo "a"
    echo "n"; echo "p"; echo "2"; echo ""; echo "-10G"
    echo "n"; echo "p"; echo "3"; echo ""; echo ""
    echo "t"; echo "3"; echo "19"
    echo "p"
    echo "w"
    echo "q"
    ) | fdisk ${SETUP_DEVICE} -W always

    echo "Formating partitions..."
    mkfs.ext2 "${SETUP_DEVICE}1"
    mkfs.btrfs -f "${SETUP_DEVICE}2"
    mkswap "${SETUP_DEVICE}3"

    echo "Mouting the disk..."
    mount "${SETUP_DEVICE}2" /mnt
    mkdir -p /mnt/boot
    mount "${SETUP_DEVICE}1" /mnt/boot
    swapon "${SETUP_DEVICE}3"
fi

echo "Updating pacman mirrors..."
echo -e "#Server = http://192.168.1.80:8080/pub/archlinux/\$repo/os/\$arch\nServer = http://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/\$repo/os/\$arch\nServer = https://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/\$repo/os/\$arch\nServer = http://glua.ua.pt/pub/archlinux/\$repo/os/\$arch\nServer = https://glua.ua.pt/pub/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo "Installing the base system..."
pacstrap /mnt base base-devel btrfs-progs

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Updating system localization..."
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo "Setting the hostname..."
echo "$SETUP_HOSTNAME" > /mnt/etc/hostname

echo "Setting hosts..."
echo "127.0.0.1\tlocalhost" > /mnt/etc/hosts
echo "::1\t\tlocalhost" >> /mnt/etc/hosts
echo "127.0.1.1\t$SETUP_HOSTNAME.localdomain\t$SETUP_HOSTNAME" >> /mnt/etc/hosts

mkdir -p /mnt/misc/

curl -L "archs.lsferreira.net/chroot-script.sh" > /mnt/misc/chroot-script.sh
chmod +x /mnt/misc/chroot-script.sh

echo "Change root into the new system"
arch-chroot /mnt ./misc/chroot-script.sh

umount -R /mnt
echo -e "\nInstallation complete! Enjoy :)"
