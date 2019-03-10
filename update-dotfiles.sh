#!/usr/bin/env bash

echo -e "Welcome to dotfiles updater\n"

if [ `id -u` -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Add wallpapers"
cp -rfv ./common/wallpapers/ /home/luis/

echo "Add git config..."
cp -rfv ./common/configs/git/.gitconfig /home/luis/

echo "Add emacs configs..."
cp -rfv ./common/configs/emacs/.emacs.d/ /home/luis/
cp -rfv ./common/configs/emacs/.emacs /home/luis/

echo "Add gimp configs..."
cp -rfv ./common/configs/gimp/.gimp-2.8/ /home/luis/

echo "Configure package manager..."
cp -rfv ./common/configs/pacman/mirrorlist /etc/pacman.d/
cp -rfv ./common/configs/pacman/pacman.conf /etc/

echo "Configure zsh..."
mkdir -p /usr/share/oh-my-zsh/themes/
cp -rfv ./common/configs/zsh/oh-my-zsh/themes/ljmf00.zsh-theme /usr/share/oh-my-zsh/themes/
cp -rfv ./common/configs/zsh/.zshrc /home/luis/
curl https://gitlab.com/aurorafossorg/utils/supershell/raw/master/supershell.sh > /home/luis/supershell.sh
mkdir -p /home/luis/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/luis/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/luis/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

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
jre-openjdk
libnotify
python2
python3
qt5-base
valgrind
vim
emacs
virtualbox
virtualbox-host-modules-arch
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
i3-gaps
i3lock
gparted
code
vulkan-intel
vulkan-devel
xorg
xorg-apps
xorg-drivers
xorg-fonts
wayland
lib32-virtualgl
alsa-firmware
alsa-oss
alsa-utils
pulseaudio
bspwm
sxhkd
lxterminal
gimp
ttf-inconsolata
ttf-droid
ttf-dejavu
ttf-freefont
ttf-liberation
ttf-gentium
ttf-ubuntu-font-family
noto-fonts
noto-fonts-cjk
noto-fonts-emoji
ttf-croscore
ttf-opensans
ttf-roboto
gparted
ntfs-3g
mtpfs
sshfs
ccache
intellij-idea-community-edition
eclipse-java
arduino
blender
"

echo "Installing common packages..."
LIST=$(echo $PACKAGES | tr -s '\n' ' ') # Replace newlines with spaces
pacman -S ${LIST} --needed --noconfirm

echo "Installing yay..."
sudo -u luis bash -c "curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay > ./PKGBUILD"
sudo -u luis -n makepkg -sicf --needed --noconfirm

rm -rfv ./yay*
rm -rfv ./PKGBUILD

AURPACKAGES="
oh-my-zsh-git
spotify
scilab
intellij-idea-ultimate-edition
wps-office
wps-office-mui-pt-pt
wps-office-extension-portuguese-dictionary
ttf-wps-fonts
ttf-ms-fonts
android-studio
blender-benchmark
osx-arc-shadow
"

echo "Installing common AUR packages..."
LIST=$(echo $AURPACKAGES | tr -s '\n' ' ')
sudo -u luis yay -S ${LIST} --needed --noconfirm

if [[ "$(hostname)" == "phobos" || "$(hostname)" == "deimos" ]]; then
    echo "Installing laptop specific..."
else
    echo "Installing desktop specific..."
    pacman -S nvidia nvidia-utils nvidia-settings lib32-nvidia-utils --needed --noconfirm
fi

echo "Updating font cache..."
fc-cache -vf

echo "Update permissions..."
chown luis:wheel -Rv /home/luis/
