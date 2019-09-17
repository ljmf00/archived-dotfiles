#!/usr/bin/env bash

# Initialization of packages list
PACKAGES=""
AURPACKAGES=""

# Add common graphical apps and themes
PACKAGES+="
	lightdm
	lightdm-gtk-greeter
	lightdm-gtk-greeter-settings
	i3-gaps
	rofi
	xsel
	compton
	gtk3
	papirus-icon-theme
"
AURPACKAGES+="
	osx-arc-shadow
	captain-frank-cursors-git
	rofimoji-git
	i3lock-color
	betterlockscreen
"

# Add common graphics interface packages and drivers
PACKAGES+="
	xorg
	xorg-apps
	xf86-input-libinput
	xf86-video-intel
	xorg-fonts
	wayland
	lib32-virtualgl
	vulkan-intel
"

# Add common fonts
PACKAGES+="
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
"
AURPACKAGES+="
	ttf-wps-fonts
	ttf-ms-fonts
	nerd-fonts-complete
	nerd-fonts-dejavu-complete
"

# Add common apps
PACKAGES+="
	git
"

# Add common text editors
PACKAGES+="
	neovim
	neovim-qt
	python-neovim
	emacs
	code
"

# Add common office software
PACKAGES+="
	libreoffice-fresh
	libreoffice-fresh-pt
	calibre
	texlive-most
	texlive-lang
	speedcrunch
	galculator
"
#AURPACKAGES+="
#	wps-office
#"
#wps-office-extension-portuguese-dictionary

# TODO: Check for virtualbox instance

# Add common development packages
PACKAGES+="
	dlang
	vulkan-devel
	jdk-openjdk
	jre-openjdk
	python2
	python3
	virtualbox
	virtualbox-host-modules-arch
	docker
	valgrind
	meson
	cmake
	automake
	make
	radare2
	radare2-cutter
	npm
"
AURPACKAGES+="
	vmware-workstation
	vmware-tools
"

# Add common utilities
PACKAGES+="
	filezilla
	htop
	iotop
	zsh
	thefuck
	vlc
	wine
	gparted
	speedtest-cli
	libnotify
	ccache
	linux-headers
	xz
	pigz
	gzip
	kitty
	ccache
	lshw
	openssh
	openssl
	pkgfile
	polkit-gnome
	gnome-keyring
	playerctl
	network-manager-applet
	screenfetch
	scrot
	feh
"
AURPACKAGES+="
	oh-my-zsh-git
	pamac-aur
	discord
	polybar
	i3-battery-popup-git
"

# Add common design and handwriting utilities
PACKAGES+="
	gimp
	krita
	xournalpp
	calligra
	inkscape
"

# Add common audio utilities and packages
PACKAGES+="
	audacity
	lmms
	alsa-firmware
	alsa-oss
	alsa-utils
	pulseaudio
	pulseaudio-equalizer
	pulseaudio-alsa
	pulseaudio-equalizer-ladspa
	jack
	pulseaudio-jack
	pavucontrol
"
AURPACKAGES+="
	spotify
	blockify
	musixmatch-bin
"

# Add common filesystem support packages
PACKAGES+="
	ntfs-3g
	mtpfs
	sshfs
"

# Games
# AURPACKAGES+="
# 	minecraft-launcher
# "

if [[ "$SETUP_HOSTNAME" == "deimos" ]]; then
	AURPACKAGES+="
		kvkbd
	"
fi

# Replace newlines with spaces and export vars
export SETUP_PACKAGELIST=$(echo $PACKAGES | tr -s '\n' ' ')
export SETUP_AURPACKAGELIST=$(echo $AURPACKAGES | tr -s '\n' ' ')