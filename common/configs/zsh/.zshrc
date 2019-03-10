# Greetings
echo " Welcome, "
echo " ┬  ┌─┐┌─┐┌─┐┬─┐┬─┐┌─┐┬┬─┐┌─┐  "
echo " │  └─┐├┤ ├┤ ├┬┘├┬┘├┤ │├┬┘├─┤  "
echo " ┴─┘└─┘└  └─┘┴└─┴└─└─┘┴┴└─┴ ┴  "                                   
echo " Last Session: $(last -1 -R $USER -n 1 | head -1 |cut -c 23-38)"

# Path to your oh-my-zsh installation.
export ZSH=/home/luis/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ljmf00"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
else
    export EDITOR='nano'
fi

# Compilation flags
#export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshconfig="$EDITOR ~/.zshrc"

autoload bashcompinit 
bashcompinit

source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/supershell.sh
eval $(thefuck --alias)

export GPG_TTY=$(tty)

#export DOCKER_HOST=tcp://127.0.0.1:32768

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi

export VISUAL=nano
export EDITOR="$VISUAL"

export USE_CCACHE=1
export WITH_SU=true

export WINEPREFIX=$HOME/.wine
export WINEARCH=win64

#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
#export _JAVA_AWT_WM_NONREPARTENTING=1

export ANDROID_HOME=/opt/android-sdk

export USE_CCACHE=1
export CCACHE_COMPRESS=1

#ccache -M 50G

setopt shwordsplit

#IRONIC_WM_NAME="LG3D"
#NET_WIN=$(xprop -root _NET_SUPPORTING_WM_CHECK | awk -F "# " '{print $2}')

#if [[ "$NET_WIN" == 0x* ]]; then
#    # xprop cannot reliably set UTF8_STRING, so we replace as string.
#    # fortunately, jdk is OK with this, but wm-spec says use UTF8_STRING.
#    xprop -id "$NET_WIN" -remove _NET_WM_NAME
#    xprop -id "$NET_WIN" -f _NET_WM_NAME 8s -set _NET_WM_NAME "$IRONIC_WM_NAME"
#else
#    # even if we're not net compatible, do java workaround
#    xprop -root -remove _NET_WM_NAME
#    xprop -root -f _NET_WM_NAME 8s -set _NET_WM_NAME "$IRONIC_WM_NAME"
#fi

#export NO_AT_BRIDGE=1

#export DISCORD_TOKEN=
#export DISCORD_TOKEN=
#export UCHATIFY_DISCORD_TOKEN=
#export YOUTUBE_DATA_API_KEY=
#export PGUSER=
#export PGDATABASE=
#export PGPASSWORD=

#export TOR_KEYBLOB=
#export TOR_KEYBLOB=
#export SEARCHFLIX_TOR_KEYBLOB=

#export SPOTIPY_CLIENT_ID=
#export SPOTIPY_CLIENT_SECRET=
#export SPOTIPY_REDIRECT_URI=
#export YOUTUBE_DEV_KEY=
