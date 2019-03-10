#!/usr/bin/env bash

#Greetings
echo -e " Welcome to installation script for Arch\n"

if [ `uname -n` -ne "archiso" ]; then
    exit 1
fi

#Starting setup
echo "Starting arch setup..."

if [ -z ${SETUP_HOSTNAME+x} ]; then
    SETUP_HOSTNAME=dummy
fi

if [ `ls /sys/firmware/efi/efivars | wc -l` -gt 1 ]; then
    echo "Great, you are on a EFI system!"
else
    echo "Hey, you are using BIOS!"
    if [ $SETUP_HOSTNAME -ne "dummy" ]; then
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

if [ -z ${SETUP_DEVICE+x} ]; then
    SETUP_DEVICE=/dev/sda
fi

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
mkfs.btrfs "${SETUP_DEVICE}2"
mkswap "${SETUP_DEVICE}3"

echo "Mouting the disk..."
mount "${SETUP_DEVICE}2" /mnt
mkdir -p /mnt/efi
mount "${SETUP_DEVICE}1" /mnt/efi
swapon "${SETUP_DEVICE}3"

echo "Updating pacman mirrors..."
echo -e "Server = http://192.168.1.80:8080/pub/archlinux/\$repo/os/\$arch\nServer = http://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/\$repo/os/\$arch\nServer = https://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/\$repo/os/\$arch\nServer = http://glua.ua.pt/pub/archlinux/\$repo/os/\$arch\nServer = https://glua.ua.pt/pub/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo "Installing the base system..."
pacstrap /mnt base base-devel btrfs-progs

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

export SETUP_HOSTNAME=$SETUP_HOSTNAME

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

if [ -z ${SETUP_WEBREMOTE+x} ]; then
    SETUP_WEBREMOTE="https://gitlab.com/lsferreira/dotfiles/raw/master"
fi

curl "$SETUP_WEBREMOTE/chroot-script.sh" > /mnt/misc/chroot-script.sh
chmod +x /mnt/misc/chroot-script.sh

echo "Change root into the new system"
arch-chroot /mnt ./misc/chroot-script.sh
