#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# BLACK="\e[30m"
# RESET_BACKGROUND="\e[49m"
# BLUE_BACKGROUND="\e[44m"
BLUE="\e[34m"
GREEN="\e[32m"
RESET="\e[39m"
TITLE="\[\e]2;$TERM: \w\a\]"
#PS1="\n$BLUE_BACKGROUND$BLACK \w $RESET_BACKGROUND$RESET$BLUE \[${RESET}\]"
PS1="${TITLE}\]\n\[${BLUE}\] \w\[${GREEN}\]\n ❯ \[${RESET}\]"

bind 'set show-all-if-ambiguous on'
shopt -s autocd
shopt -s checkwinsize

#env var
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"
export PATH="${PATH}:$HOME/.local/bin"
export EDITOR="nvim"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export MESA_SHADER_CACHE_DIR="$XDG_CACHE_HOME/mesa_shader_cache"
export GOPATH="$XDG_DATA_HOME/go"
export HISTFILESIZE=""

#aliases
alias ls='ls -A --color=auto'
alias n='nvim'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias c="cargo"
#alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias soft-reboot='systemctl soft-reboot'
alias tree='tree -C -L 2'
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
complete -F _command doas

#if uwsm check may-start && uwsm select; then
#	exec systemd-cat -t uwsm_start uwsm start default
#fi
if [[ "$XDG_SESSION_TYPE" = "tty" ]]; then
    if uwsm check may-start; then
        exec systemd-cat -t uwsm_start uwsm start hyprland.desktop
    fi
fi

function compress-video ()
{
    ffmpeg -i $1 -vcodec libx264 -crf 24 $2
}
