#!/usr/bin/env bash

# Initialization of packages list
PACKAGES=""
AURPACKAGES=""

# Add common graphical apps and themes
PACKAGES+="
	plasma
	kde-applications
	plasma-wayland-session
	lightdm
	lightdm-gtk-greeter
	conky
	i3-gaps
	i3lock
	bspwm
	sxhkd
	dmenu
	qt5-base
	gtk2
	gtk3
	papirus-icon-theme
"
AURPACKAGES+="
	osx-arc-shadow
	captain-frank-cursors-git
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
"

# Add common apps
PACKAGES+="
	git
"

# Add common text editors
PACKAGES+="
	vim
	neovim
	neovim-qt
	python-neovim
	emacs
	code
"
AURPACKAGES+="
    ycmd-git
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
AURPACKAGES+="
	wps-office
"
#wps-office-extension-portuguese-dictionary

# TODO: Check for virtualbox instance

# Add common development packages
PACKAGES+="
	intellij-idea-community-edition
	eclipse-java
	arduino
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
"
AURPACKAGES+="
	intellij-idea-ultimate-edition
	android-studio
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
	tilix
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
	ccache
	lshw
"
AURPACKAGES+="
	blender-benchmark
	oh-my-zsh-git
	pamac-aur
	discord
"

# Add common design and handwriting utilities
PACKAGES+="
	gimp
	krita
	xournal
	calligra
	blender
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
AURPACKAGES+="
	minecraft-launcher
"

if [ "$SETUP_HOSTNAME" = "deimos" ]; then
	AURPACKAGES+="
		kvkbd
	"
fi

# Replace newlines with spaces and export vars
export SETUP_PACKAGELIST=$(echo $PACKAGES | tr -s '\n' ' ')
export SETUP_AURPACKAGELIST=$(echo $AURPACKAGES | tr -s '\n' ' ')