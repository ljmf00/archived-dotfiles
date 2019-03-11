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
