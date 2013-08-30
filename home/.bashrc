# Define my XDG dirs for things like powerline
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS}:${HOME}/.my_config:/etc/xdg"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
history -a

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=/usr/bin/vim

# powerline prompt
export PATH="${PATH}:${HOME}/.local/bin"
. $(find ${HOME}/.local/ -wholename "*powerline/bindings/bash/powerline.sh")

# Hook to make local changes
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

export PATH="/usr/local/heroku/bin:$PATH"

if [ -f ~/.rvm/scripts/rvm ]; then
    . ~/.rvm/scripts/rvm
fi
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
