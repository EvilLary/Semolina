#
# ~/.bashrc
#
# if [ "$TERM" = "linux" ]; then
#     printf "\033]P0%s" "1f1f1f"
#     printf "\033]P1%s" "f44747"
#     printf "\033]P2%s" "608b4e"
#     printf "\033]P3%s" "dcdcaa"
#     printf "\033]P4%s" "569cd6"
#     printf "\033]P5%s" "c678dd"
#     printf "\033]P6%s" "56b6c2"
#     printf "\033]P7%s" "d4d4d4"
#     printf "\033]P8%s" "808080"
#     printf "\033]P9%s" "f44747"
#     printf "\033]PA%s" "608b4e"
#     printf "\033]PB%s" "dcdcaa"
#     printf "\033]PC%s" "569cd6"
#     printf "\033]PD%s" "c678dd"
#     printf "\033]PE%s" "56b6c2"
#     printf "\033]PF%s" "d4d4d4"
# fi
# clear
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "/usr/share/git/completion/git-prompt.sh"
export GIT_PS1_SHOWDIRTYSTATE="1"
export GIT_PS1_SHOWUNTRACKEDFILES="1"
export GIT_PS1_SHOWCOLORHINTS="1"
PS1='\[\e]2;$TERM: \w\a\] \[\e[34m\]\w\[\e[0m\]$(__git_ps1 " (%s)")\n\[\e[32m\] $\[\e[0m\] '
bind 'set show-all-if-ambiguous on'
shopt -s autocd
shopt -s checkwinsize

#env var
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="${PATH}:$HOME/.local/bin:$CARGO_HOME/bin"
export EDITOR="nvim"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export MESA_SHADER_CACHE_DIR="$XDG_CACHE_HOME/mesa_shader_cache"
export GOPATH="$XDG_DATA_HOME/go"
export HISTFILESIZE=""
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
# export BROWSER="librewolf"

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
alias ..="cd .."
alias shell="QML_IMPORT_PATH="{$QML_IMPORT_PATH}:/home/spicy/.config/quickshell/shell" qs -c shell --log-rules 'quickshell.dbus.properties.warning = false'"
alias qsnew="qs -c new -d --log-rules 'quickshell.dbus.properties.warning = false'"
alias xdghypr="systemctl --user restart xdg-desktop-portal-hyprland.service "
alias vim="nvim"
# complete -F _complete_alias c

#if uwsm check may-start && uwsm select; then
#	exec systemd-cat -t uwsm_start uwsm start default
#fi
if [[ "$XDG_SESSION_TYPE" = "tty" ]]; then
    if uwsm check may-start; then
        exec systemd-cat -t uwsm_start uwsm start hyprland.desktop
    fi
fi

function compress-video() {
    ffmpeg -i $1 -vcodec libx264 -crf 24 $2
}
