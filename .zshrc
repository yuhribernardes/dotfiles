eval $(starship init zsh)

# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# ZSH_THEME="powerlevel10k/powerlevel10k"

# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

. $HOME/.asdf/asdf.sh

plugins=(
    git               # git aliases and utilities
    docker
    docker-compose
)

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

zplugin light zdharma/fast-syntax-highlighting

zplugin light zsh-users/zsh-completions
zplugin light zsh-users/zsh-autosuggestions

fpath=($HOME/.zsh/completions/ ${ASDF_DIR}/completions/ $fpath)
autoload -Uz compinit && compinit

eval $(gh completion -s zsh 2> /dev/null)

complete -C $(which aws_completer) aws 2> /dev/null

source <(kubectl completion zsh) 2> /dev/null

source /opt/google-cloud-sdk/completion.zsh.inc

go_mod() {
    MAIN_PATH=~/go
    echo "dotenv" >> .envrc

    echo "" > .env
    echo "GOPATH=$MAIN_PATH" >> .env
    echo "GOBIN=$MAIN_PATH/bin" >> .env
    echo "GO111MODULE=on" >> .env

    echo "PATH_add $MAIN_PATH/bin" >> .envrc

    direnv allow
    direnv reload
}

go_dep (){

    MAIN_PATH="$(pwd)"

    echo "dotenv" >> .envrc


    echo "" > .env
    echo "GOPATH=$MAIN_PATH" >> .env
    echo "GOBIN=$MAIN_PATH/bin" >> .env
    echo "GO111MODULE=off" >> .env

    echo "PATH_add $MAIN_PATH/bin" >> .envrc

    direnv allow
    direnv reload

}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(navi widget zsh)

export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd --hidden --type f"
export FZF_DEFAULT_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

cd_fzf (){
    cd $HOME && cd $(fd --hidden -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    clear
}

bindkey -s "^[c" "cd_fzf^M"

if [ -f /opt/shell-color-scripts/colorscript.sh ] ; then
/opt/shell-color-scripts/colorscript.sh -e $(echo "32\n41\n42" | shuf -n1)
fi

if [ $(command -v direnv) ] ; then
    eval "$(direnv hook zsh)"
fi

if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

export PATH="$PATH:$HOME/go/bin"

export TERM=alacritty

export EDITOR=/usr/bin/nvim

alias t='/usr/bin/tmux -f ~/.tmux.conf'

alias gitkraken='gitkraken > /dev/null & disown %gitkraken'

reload() {
	local cache="$ZSH_CACHE_DIR"
	autoload -U compinit zrecompile
	compinit -i -d "$cache/zcomp-$HOST"

	for f in ${ZDOTDIR:-~}/.zshrc "$cache/zcomp-$HOST"; do
		zrecompile -p $f && command rm -f $f.zwc.old
	done

	# Use $SHELL if it's available and a zsh shell
	local shell="$ZSH_ARGZERO"
	if [[ "${${SHELL:t}#-}" = zsh ]]; then
		shell="$SHELL"
	fi

	# Remove leading dash if login shell and run accordingly
	if [[ "${shell:0:1}" = "-" ]]; then
		exec -l "${shell#-}"
	else
		exec "$shell"
	fi

    clear
}

alias new-ssh='ssh-keygen -t rsa -b 4096 -C'

alias cra='create-react-app'

alias pbcopy='xclip -selection clipboard'

alias ..='cd ..'
alias ...='cd ../..'

alias ls='exa --color=always --group-directories-first' # my preferred listing
alias la='exa -lah --git --color=always --group-directories-first'  # all files and dirs
alias ll='exa -lh --git --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing

alias cls='clear'

alias open="xdg-open"

alias d='docker'
alias dc='docker-compose'

alias emacs='LANG=pt_BR.utf8 && emacs & disown %emacs'

alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cfga='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add'
alias cfgs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status'
alias cfgc='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m'
alias cfgp='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME push origin main'

alias g='git'
alias gsts='git status'
alias ga='git add'
alias gaa='git add --all'
alias gcl='git clone'
alias gcmm="git commit -m"
alias gcm="git commit"
alias gl='git pull'

alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

alias gr='git remote'
alias gra='git remote add'
alias grup='git remote update'
alias grv='git remote -v'

alias gist='navi --best-match -q "fetch gist"'

function emacs_prepare_go {
    echo "Installing gore"
    go get -u github.com/motemen/gore/cmd/gore
    echo "Installing gocode"
    go get -u github.com/stamblerre/gocode
    echo "Installing godoc"
    go get -u golang.org/x/tools/cmd/godoc
    echo "Installing goimports"
    go get -u golang.org/x/tools/cmd/goimports
    echo "Installing gorename"
    go get -u golang.org/x/tools/cmd/gorename
    echo "Installing guru"
    go get -u golang.org/x/tools/cmd/guru
    echo "Installing gotest/..."
    go get -u github.com/cweill/gotests/...
    echo "Installing gomodifytags"
    go get -u github.com/fatih/gomodifytags
    echo "installing gopls"
    go get golang.org/x/tools/gopls
}

function gi {
    if [ "$1" != "-a" ]; then
        echo "" > ./.gitignore
    fi
    GOPATH=$HOME/go
    for template in $(gogi -list | sed 's/\,/\n/g' | fzf -m);do
        gogi -create $template >> .gitignore
    done
}

vpn () {
    VPN_LOCATION="$HOME/.accesses/paygo"

    if [ $1 = office ] ;then

        sudo openfortivpn -c $VPN_LOCATION/office.conf

    elif [ $1 = kafka ]; then
        sudo openvpn \
            --config $VPN_LOCATION/kafka/kafka.ovpn \
            --cert $VPN_LOCATION/kafka/kafka.crt \
            --key $VPN_LOCATION/kafka/kafka.key \
            --auth-retry interact
    fi
}

SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

function sga {
    pkill gpg-agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
}

sga
