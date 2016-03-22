###################
# Begin OH MY ZSH #
###################

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git go composer docker meteor)

source $ZSH/oh-my-zsh.sh

#################
# End OH MY ZSH #
#################

# Style My prompt
COLOR_DEBUG=""
for COLOR in CYAN WHITE YELLOW MAGENTA BLACK BLUE RED DEFAULT GREEN GREY; do
    eval COLOR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval COLOR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    COLOR_DEBUG=${COLOR_DEBUG}${reset_color}$fg[${(L)COLOR}]"COLOR_$COLOR\t"
    COLOR_DEBUG=${COLOR_DEBUG}${reset_color}$fg_bold[${(L)COLOR}]"COLOR_BRIGHT_$COLOR"
    COLOR_DEBUG=${COLOR_DEBUG}"\n"
done
COLOR_RESET="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" ${COLOR_RESET}${COLOR_BLUE}(⎇ "
ZSH_THEME_GIT_PROMPT_SUFFIX="${COLOR_RESET}${COLOR_BLUE})"
ZSH_THEME_GIT_PROMPT_DIRTY="${COLOR_RESET}${COLOR_RED} ✘${COLOR_RESET}"
ZSH_THEME_GIT_PROMPT_CLEAN="${COLOR_RESET}${COLOR_GREEN} ✔${COLOR_RESET}"

# Prevent python virtualenv from mucking with my prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
function virtualenv_prompt_info() {
    [[ "" == $VIRTUAL_ENV ]] && return

    print " ${COLOR_RESET}${COLOR_MAGENTA}鱧$(basename $VIRTUAL_ENV)${COLOR_RESET}"
}

PROMPT=$COLOR_CYAN'%4~$(virtualenv_prompt_info)$(git_prompt_info)'$COLOR_BLACK'%(1j. %j.)'$COLOR_RESET$COLOR_BRIGHT_RED'%(?.. %?)'$COLOR_RESET$COLOR_CYAN' $'$COLOR_RESET' '

# Use vimx when available for better X integration
if [ -e /usr/bin/vimx ]; then
    export EDITOR=/usr/bin/vimx
elif [ -e /usr/local/bin/vim ]; then
    export EDITOR=/usr/local/bin/vim
elif [ -e /usr/bin/vim ]; then
    export EDITOR=/usr/bin/vim
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin

# RVM TODO maybe use a omz plugin?
[ -f ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm
PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Node.js NVM
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" || true

[ -f ~/.bash_aliases ] && . ~/.bash_aliases || true

# Hook to make local changes
[ -f ~/.zshrc_local ] && . ~/.zshrc_local || true

### Added by the Heroku Toolbelt
export PATH="$PATH:/usr/local/heroku/bin"

# Android tools
export PATH="$PATH:/Users/jwalker/Library/Android/sdk/platform-tools"
