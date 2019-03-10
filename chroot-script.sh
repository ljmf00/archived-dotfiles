#!/usr/bin/env bash

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
passwd
passwd luis

echo "Installing grub..."
if [ $SETUP_HOSTNAME -ne "dummy" ]; then
    pacman -S grub os-prober efibootmgr --noconfirm
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id="Arch Linux"
else
    pacman -S grub os-prober --noconfirm
    grub-install --target=i386-pc $SETUP_DEVICE
fi
grub-mkconfig -o /boot/grub/grub.cfg
