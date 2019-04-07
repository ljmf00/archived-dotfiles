#!/usr/bin/env bash

# Variable initialization
if [ -z ${SETUP_ALLOWERROR+x} ]; then
	SETUP_ALLOWERROR=0
fi

if [ -z ${SETUP_PRIVATE+x} ]; then
	SETUP_PRIVATE=0
fi
# TODO: Add the private part

if [ -z ${SETUP_VERBOSE+x} ]; then
	SETUP_VERBOSE=0
fi

if [ -z ${SETUP_HOSTNAME+x} ]; then
	SETUP_HOSTNAME=`hostname`
fi

# Exit on the first error
if [ "$SETUP_ALLOWERROR" = '0' ]; then
	set -e
fi

# Set output file descriptor
if [ "$SETUP_VERBOSE" = 1 ]; then
	SETUP_OUTPUT_DESCRIPTOR="/dev/stdout"
	SETUP_CP="cp -v"
	SETUP_RM="rm -v"
	SETUP_CHOWN="chown -v"
	SETUP_CHMOD="chmod -v"
	SETUP_FC_CACHE="fc-cache -v"
	SETUP_MKDIR="mkdir -v"
else
	SETUP_OUTPUT_DESCRIPTOR="/dev/null"
	SETUP_CP="cp"
	SETUP_RM="rm"
	SETUP_CHOWN="chown"
	SETUP_CHMOD="chmod"
	SETUP_FC_CACHE="fc-cache"
	SETUP_MKDIR="mkdir"
fi

# Greetings
echo -e "\e[95m-->\e[0m \e[1mWelcome to dotfiles updater\e[0m"

# Check for root permissions
if [ `id -u` -ne 0 ]; then
	echo -e "\e[91m==>\e[0m \e[1mThis script must be run as root\e[0m" 1>&2
	exit 1
fi

# Check for git
if ! [ -x "$(command -v git)" ]; then
	echo -e "\e[92m-->\e[0m \e[1mInstalling git...\e[0m"
	pacman -S git --noconfirm > $SETUP_OUTPUT_DESCRIPTOR
fi

# Make initial config folders
echo -e "\e[92m-->\e[0m \e[1mMake initial config folders...\e[0m"
$SETUP_MKDIR -p /home/luis/.config/ > $SETUP_OUTPUT_DESCRIPTOR

# Add wallpapers
echo -e "\e[92m-->\e[0m \e[1mAdd wallpapers\e[0m"
$SETUP_CP -rf ./common/wallpapers/ /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR

# Git configuration
echo -e "\e[92m-->\e[0m \e[1mAdd git config...\e[0m"
$SETUP_CP -rf ./common/configs/git/.gitconfig /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR

# Emacs configuration
echo -e "\e[92m-->\e[0m \e[1mAdd emacs configs...\e[0m"
$SETUP_CP -rf ./common/configs/emacs/.emacs.d/ /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/emacs/.emacs /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR

# GIMP Configuration
echo -e "\e[92m-->\e[0m \e[1mAdd gimp configs...\e[0m"
$SETUP_CP -rf ./common/configs/gimp/.gimp-2.8/ /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR

# Package Manager
echo -e "\e[92m-->\e[0m \e[1mConfigure package manager...\e[0m"
$SETUP_CP -rf ./common/configs/pacman/mirrorlist /etc/pacman.d/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/pacman/pacman.conf /etc/ > $SETUP_OUTPUT_DESCRIPTOR

# Makepkg config
echo -e "\e[92m-->\e[0m \e[1mConfigure makepkg...\e[0m"
$SETUP_CP -rf ./common/configs/makepkg/makepkg.conf /etc/ > $SETUP_OUTPUT_DESCRIPTOR
# TODO: Add makepkg for distcc config

# Makepkg config
echo -e "\e[92m-->\e[0m \e[1mConfigure gnupg...\e[0m"
$SETUP_MKDIR -p /root/.gnupg/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_MKDIR -p /home/luis/.gnupg/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gnupg/gpg.conf /etc/pacman.d/gnupg/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gnupg/gpg.conf /root/.gnupg/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gnupg/gpg.conf /home/luis/.gnupg/ > $SETUP_OUTPUT_DESCRIPTOR


echo -e "\e[92m-->\e[0m \e[1mConfigure GTK...\e[0m"
$SETUP_MKDIR -p /home/luis/.config/gtk-3.0/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gtk/.gtkrc-2.0 /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gtk/gtkrc-2.0 /home/luis/.config/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gtk/gtkrc /home/luis/.config/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/gtk/gtk-3.0/settings.ini /home/luis/.config/gtk-3.0/ > $SETUP_OUTPUT_DESCRIPTOR

echo -e "\e[92m-->\e[0m \e[1mConfigure Visual Studio Code...\e[0m"
$SETUP_MKDIR -p "/home/luis/.config/Code - OSS/User/" > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/code/settings.json "/home/luis/.config/Code - OSS/User/" > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/code/keybindings.json "/home/luis/.config/Code - OSS/User/" > $SETUP_OUTPUT_DESCRIPTOR

# Sudo temporary permission
echo -e "\e[92m-->\e[0m \e[1mCreate temporary permissions for sudo...\e[0m"
echo "root ALL=(ALL) ALL" > /etc/sudoers
echo "luis ALL = NOPASSWD : ALL" >> /etc/sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# TODO: Update lightdm configs

# TODO: Fix Tilix command
# Configure Tilix
#sudo -u luis -n bash -c "dconf load /com/gexperts/Tilix/ < ./common/configs/tilix/tilix.dconf" > $SETUP_OUTPUT_DESCRIPTOR

# ZSH Configurations
echo -e "\e[92m-->\e[0m \e[1mConfigure zsh...\e[0m"
$SETUP_MKDIR -p /usr/share/oh-my-zsh/themes/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/zsh/oh-my-zsh/themes/ljmf00.zsh-theme /usr/share/oh-my-zsh/themes/ > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CP -rf ./common/configs/zsh/.zshrc /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR

echo -e "\e[92m-->\e[0m \e[1mInstalling supershell...\e[0m"
bash -c "curl https://gitlab.com/aurorafossorg/utils/supershell/raw/master/supershell.sh > /home/luis/supershell.sh" > $SETUP_OUTPUT_DESCRIPTOR

echo -e "\e[92m-->\e[0m \e[1mInstalling zsh plugins...\e[0m"
$SETUP_MKDIR -p /home/luis/.oh-my-zsh/custom/plugins/ > $SETUP_OUTPUT_DESCRIPTOR

echo -e "\e[92m-->\e[0m \e[1mScan remote ssh keys for git cloning...\e[0m"
$SETUP_MKDIR -p /home/luis/.ssh/
touch /home/luis/.ssh/known_hosts
if [ ! -n "$(grep "^github.com " /home/luis/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> /home/luis/.ssh/known_hosts 2>/dev/null; fi
if [ ! -n "$(grep "^gitlab.com " /home/luis/.ssh/known_hosts)" ]; then ssh-keyscan gitlab.com >> /home/luis/.ssh/known_hosts 2>/dev/null; fi

# ZSH Plugin: zsh-autosuggestions
ZSH_PLUGIN_DIR="/home/luis/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ -d "$ZSH_PLUGIN_DIR" ]; then
	# Updating
	echo -e "\e[92m-->\e[0m \e[1mUpdating zsh-autosuggestions plugin...\e[0m"
	pushd "$ZSH_PLUGIN_DIR" > $SETUP_OUTPUT_DESCRIPTOR
	git pull > $SETUP_OUTPUT_DESCRIPTOR
	popd > $SETUP_OUTPUT_DESCRIPTOR
else
	# Installing
	echo -e "\e[92m-->\e[0m \e[1mInstalling zsh-autosuggestions plugin...\e[0m"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGIN_DIR" > $SETUP_OUTPUT_DESCRIPTOR
fi

# ZSH Plugin: zsh-syntax-highlighting
ZSH_PLUGIN_DIR="/home/luis/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ -d "$ZSH_PLUGIN_DIR" ]; then
	# Updating
	echo -e "\e[92m-->\e[0m \e[1mUpdating zsh-syntax-highlighting plugin...\e[0m"
	pushd "$ZSH_PLUGIN_DIR" > $SETUP_OUTPUT_DESCRIPTOR
	git pull > $SETUP_OUTPUT_DESCRIPTOR
	popd > $SETUP_OUTPUT_DESCRIPTOR
else
	# Installing
	echo -e "\e[92m-->\e[0m \e[1mInstalling zsh-syntax-highlighting plugin...\e[0m"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGIN_DIR" > $SETUP_OUTPUT_DESCRIPTOR
fi

chsh -s /usr/bin/zsh luis

# Updating pacman repos
echo -e "\e[92m-->\e[0m \e[1mUpdating pacman repositories...\e[0m"
pacman -Sy --noconfirm > $SETUP_OUTPUT_DESCRIPTOR

source ./packages.sh

echo -e "\e[92m-->\e[0m \e[1mInstalling common packages...\e[0m"
pacman -S ${SETUP_PACKAGELIST} --needed --noconfirm > $SETUP_OUTPUT_DESCRIPTOR

# Install vscode configs
echo -e "\e[92m-->\e[0m \e[1mInstalling vscode packages...\e[0m"
# Install vscode extension
sudo -u luis -n code-oss --force --install-extension aurorafoss.vscode-bettercoder > $SETUP_OUTPUT_DESCRIPTOR # BetterCoder
sudo -u luis -n code-oss --force --install-extension eamodio.gitlens > $SETUP_OUTPUT_DESCRIPTOR # Gitlens
sudo -u luis -n code-oss --force --install-extension MS-vsliveshare.vsliveshare-pack > $SETUP_OUTPUT_DESCRIPTOR # VSLive Share
sudo -u luis -n code-oss --force --install-extension redhat.java > $SETUP_OUTPUT_DESCRIPTOR # RedHat Support for Java
sudo -u luis -n code-oss --force --install-extension vscjava.vscode-maven > $SETUP_OUTPUT_DESCRIPTOR # Maven
sudo -u luis -n code-oss --force --install-extension vscode-icons-team.vscode-icons > $SETUP_OUTPUT_DESCRIPTOR # VSCode Icons
sudo -u luis -n code-oss --force --install-extension Zignd.html-css-class-completion > $SETUP_OUTPUT_DESCRIPTOR # CSS Class Intellisense
sudo -u luis -n code-oss --force --install-extension ms-python.python > $SETUP_OUTPUT_DESCRIPTOR # MS Python Extension
sudo -u luis -n code-oss --force --install-extension dbaeumer.vscode-eslint > $SETUP_OUTPUT_DESCRIPTOR # VSCode ESLint
sudo -u luis -n code-oss --force --install-extension msjsdiag.debugger-for-chrome > $SETUP_OUTPUT_DESCRIPTOR # Debugger for Chrome
sudo -u luis -n code-oss --force --install-extension ms-vscode.cpptools > $SETUP_OUTPUT_DESCRIPTOR # MS C/C++ Extension
sudo -u luis -n code-oss --force --install-extension ms-vscode.vscode-typescript-tslint-plugin > $SETUP_OUTPUT_DESCRIPTOR # MS TSLint
sudo -u luis -n code-oss --force --install-extension ms-vscode.csharp > $SETUP_OUTPUT_DESCRIPTOR # MS C#
sudo -u luis -n code-oss --force --install-extension octref.vetur > $SETUP_OUTPUT_DESCRIPTOR # VueJS Extension
sudo -u luis -n code-oss --force --install-extension PeterJausovec.vscode-docker > $SETUP_OUTPUT_DESCRIPTOR # Docker
sudo -u luis -n code-oss --force --install-extension ms-vscode.Go > $SETUP_OUTPUT_DESCRIPTOR # MS Go Extension
sudo -u luis -n code-oss --force --install-extension HookyQR.beautify > $SETUP_OUTPUT_DESCRIPTOR # Beautify
sudo -u luis -n code-oss --force --install-extension esbenp.prettier-vscode > $SETUP_OUTPUT_DESCRIPTOR # Prettier
sudo -u luis -n code-oss --force --install-extension shyykoserhiy.vscode-spotify > $SETUP_OUTPUT_DESCRIPTOR # Spotify
sudo -u luis -n code-oss --force --install-extension asabil.meson > $SETUP_OUTPUT_DESCRIPTOR # Meson
sudo -u luis -n code-oss --force --install-extension 13xforever.language-x86-64-assembly > $SETUP_OUTPUT_DESCRIPTOR # x86_64 Assembly
sudo -u luis -n code-oss --force --install-extension kdarkhan.mips > $SETUP_OUTPUT_DESCRIPTOR # MIPS
sudo -u luis -n code-oss --force --install-extension vscjava.vscode-java-debug > $SETUP_OUTPUT_DESCRIPTOR # Debugger for Java
sudo -u luis -n code-oss --force --install-extension naco-siren.gradle-language > $SETUP_OUTPUT_DESCRIPTOR # Gradle language support
sudo -u luis -n code-oss --force --install-extension webfreak.debug > $SETUP_OUTPUT_DESCRIPTOR # Native Debug
sudo -u luis -n code-oss --force --install-extension webfreak.code-d > $SETUP_OUTPUT_DESCRIPTOR # Code-D
sudo -u luis -n code-oss --force --install-extension dlang-vscode.dlang > $SETUP_OUTPUT_DESCRIPTOR # Dlang extension
sudo -u luis -n code-oss --force --install-extension torn4dom4n.latex-support > $SETUP_OUTPUT_DESCRIPTOR # Latex support
sudo -u luis -n code-oss --force --install-extension sabertazimi.latex-snippets > $SETUP_OUTPUT_DESCRIPTOR # Latex snippets
sudo -u luis -n code-oss --force --install-extension dan-c-underwood.arm > $SETUP_OUTPUT_DESCRIPTOR # ARM Assembly support
sudo -u luis -n code-oss --force --install-extension mammothb.scilab > $SETUP_OUTPUT_DESCRIPTOR # Scilab
sudo -u luis -n code-oss --force --install-extension felixfbecker.php-intellisense > $SETUP_OUTPUT_DESCRIPTOR # PHP Intellisense
sudo -u luis -n code-oss --force --install-extension EditorConfig.EditorConfig > $SETUP_OUTPUT_DESCRIPTOR # EditorConfig
sudo -u luis -n code-oss --force --install-extension formulahendry.auto-close-tag > $SETUP_OUTPUT_DESCRIPTOR # Automatic close tag HTML/XML
sudo -u luis -n code-oss --force --install-extension alefragnani.project-manager > $SETUP_OUTPUT_DESCRIPTOR # Project Manager
sudo -u luis -n code-oss --force --install-extension abusaidm.html-snippets > $SETUP_OUTPUT_DESCRIPTOR # HTML Snippets
sudo -u luis -n code-oss --force --install-extension alefragnani.Bookmarks > $SETUP_OUTPUT_DESCRIPTOR # Bookmarks
sudo -u luis -n code-oss --force --install-extension rafamel.subtle-brackets > $SETUP_OUTPUT_DESCRIPTOR # Subtle Brackets
sudo -u luis -n code-oss --force --install-extension 2gua.rainbow-brackets > $SETUP_OUTPUT_DESCRIPTOR # Rainbow brackets
sudo -u luis -n code-oss --force --install-extension VisualStudioExptTeam.vscodeintellicode > $SETUP_OUTPUT_DESCRIPTOR # IntelliCode
sudo -u luis -n code-oss --force --install-extension mechatroner.rainbow-csv > $SETUP_OUTPUT_DESCRIPTOR # Rainbow CSV
sudo -u luis -n code-oss --force --install-extension Dart-Code.dart-code > $SETUP_OUTPUT_DESCRIPTOR # Dart Support
sudo -u luis -n code-oss --force --install-extension robinbentley.sass-indented > $SETUP_OUTPUT_DESCRIPTOR # Sass support
sudo -u luis -n code-oss --force --install-extension Dart-Code.flutter > $SETUP_OUTPUT_DESCRIPTOR # Flutter
sudo -u luis -n code-oss --force --install-extension thekalinga.bootstrap4-vscode > $SETUP_OUTPUT_DESCRIPTOR # Bootstrap snippets
sudo -u luis -n code-oss --force --install-extension vsciot-vscode.vscode-arduino > $SETUP_OUTPUT_DESCRIPTOR # MS Arduino
sudo -u luis -n code-oss --force --install-extension LaurentTreguier.vscode-dls > $SETUP_OUTPUT_DESCRIPTOR # VSCode Dlang DLS
sudo -u luis -n code-oss --force --install-extension christian-kohler.path-intellisense > $SETUP_OUTPUT_DESCRIPTOR # Path IntelliSense
sudo -u luis -n code-oss --force --install-extension oderwat.indent-rainbow > $SETUP_OUTPUT_DESCRIPTOR # Indent rainbow
sudo -u luis -n code-oss --force --install-extension platformio.platformio-ide > $SETUP_OUTPUT_DESCRIPTOR # PlatformIO IDE
sudo -u luis -n code-oss --force --install-extension wayou.vscode-todo-highlight > $SETUP_OUTPUT_DESCRIPTOR # TODO Highlighter
sudo -u luis -n code-oss --force --insatll-extension rebornix.Ruby > $SETUP_OUTPUT_DESCRIPTOR # Ruby

if [ "$SETUP_HOSTNAME" = "deimos" ]; then
	echo -e "\e[92m-->\e[0m \e[1mConfigure xorg touchpad config...\e[0m"
	$SETUP_CP -rf ./deimos/configs/xorg/30-touchpad.conf /etc/X11/xorg.conf.d/ > $SETUP_OUTPUT_DESCRIPTOR

	if [ -d "./deimos/patches/" ]; then
		echo -e "\e[92m-->\e[0m \e[1mUpdating laptop specific configs...\e[0m"
		pushd ./deimos/patches/ > $SETUP_OUTPUT_DESCRIPTOR
		git pull > $SETUP_OUTPUT_DESCRIPTOR
		popd > $SETUP_OUTPUT_DESCRIPTOR
	else
		echo -e "\e[92m-->\e[0m \e[1mInstalling laptop specific configs...\e[0m"
		echo -e "\e[92m-->\e[0m \e[1mCloning Teclast F6 Pro specific kernel patches...\e[0m"
		$SETUP_MKDIR -p ./deimos/patches/ > $SETUP_OUTPUT_DESCRIPTOR
		git clone https://gitlab.com/lsferreira/dotfiles_teclast-f6pro.git ./deimos/patches/ > $SETUP_OUTPUT_DESCRIPTOR
	fi
fi

if ! [ -x "$(command -v yay)" ]; then
	echo -e "\e[92m-->\e[0m \e[1mInstalling yay...\e[0m"
	sudo -u luis -n bash -c "curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay > ./PKGBUILD" > $SETUP_OUTPUT_DESCRIPTOR
	sudo -u luis -n makepkg -sicf --needed --noconfirm > $SETUP_OUTPUT_DESCRIPTOR

	$SETUP_RM -rf ./yay* > $SETUP_OUTPUT_DESCRIPTOR
	$SETUP_RM -rf ./PKGBUILD > $SETUP_OUTPUT_DESCRIPTOR
fi

echo "Installing common AUR packages..."
sudo -u luis yay -S ${SETUP_AURPACKAGELIST} --needed --noconfirm > $SETUP_OUTPUT_DESCRIPTOR

echo "Restructure sudo permissions..."
$SETUP_CP -f ./common/configs/sudo/sudoers /etc/sudoers > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CHOWN root:root /etc/sudoers > $SETUP_OUTPUT_DESCRIPTOR
$SETUP_CHMOD 440 /etc/sudoers > $SETUP_OUTPUT_DESCRIPTOR

if [[ "$(hostname)" == "phobos" || "$(hostname)" == "deimos" ]]; then
	echo
else
	echo "Installing desktop specific..."
	pacman -S nvidia nvidia-utils nvidia-settings lib32-nvidia-utils --needed --noconfirm > $SETUP_OUTPUT_DESCRIPTOR
fi

echo -e "\e[92m-->\e[0m \e[1mUpdating font cache...\e[0m"
fc-cache -f > $SETUP_OUTPUT_DESCRIPTOR

echo -e "\e[92m-->\e[0m \e[1mUpdate permissions...\e[0m"
chown luis:wheel -R /home/luis/ > $SETUP_OUTPUT_DESCRIPTOR

echo -e "\e[95m-->\e[0m \e[1mDotfiles updated\e[0m"