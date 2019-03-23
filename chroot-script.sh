#!/usr/bin/env bash

# Exit on the first error
if [ "$SETUP_ALLOWERROR" = '0' ]; then
    set -e
fi

# Variable initialization in case of no setup
if [ -z ${SETUP_INSTALLATION+x} ]; then
    SETUP_INSTALLATION=0
fi

# Greetings
echo -e "\e[95m-->\e[0m \e[1mWelcome to chroot installation script\e[0m"

# Check if the script is running inside setup script
if [ "$SETUP_INSTALLATION" -ne 1 ]; then
    echo -e "\e[91m==>\e[0m \e[1mThis script must be run with setup script\e[0m" 1>&2
    exit 1
fi

echo -e "Welcome to your clean chroot!\n"

echo "Setting the timezone..."
ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime

echo "Ajust time with hardware clock"
hwclock --systohc

echo "Updating system localization..."
locale-gen

mkinitcpio -p linux

echo "Creating user"
useradd -G wheel -m luis

echo "Changing passwords..."
echo -e "changeme\nchangeme" | passwd root
echo -e "changeme\nchangeme" | passwd luis

echo "Installing grub..."
pacman -S grub os-prober intel-ucode --noconfirm
if [ $SETUP_HOSTNAME -ne "dummy" ]; then
    pacman -S efibootmgr --noconfirm
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id="Arch Linux"
else
    grub-install --target=i386-pc $SETUP_DEVICE
fi
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S git --noconfirm

git clone https://gitlab.com/lsferreira/dotfiles /misc/dotfiles/

chmod +x /misc/dotfiles/update-dotfiles.sh

chown luis:luis -Rv /misc/

pushd /misc/dotfiles/
/misc/dotfiles/update-dotfiles.sh
popd

rm -rfv /misc/

exit
