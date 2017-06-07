###################
# Begin OH MY ZSH #
###################

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git go rvm docker kubectl)

source $ZSH/oh-my-zsh.sh

#################
# End OH MY ZSH #
#################

source $HOME/.zshrc_prompt  # Style my prompt
source $HOME/.zshrc_funcs   # Some useful homemade functions
source $HOME/.zshrc_aliases # Define some aliases

# Define $EDITOR. Use vimx when available for better X integration
if [ -e /usr/bin/vimx ]; then
    export EDITOR=/usr/bin/vimx
elif [ -e /usr/local/bin/vim ]; then
    export EDITOR=/usr/local/bin/vim
elif [ -e /usr/bin/vim ]; then
    export EDITOR=/usr/bin/vim
fi

# Define customizations to $PATH
export PATH=$PATH:$HOME/bin:$HOME/.local/bin                        # Local binaries I might make
export PATH=$PATH:$GOPATH/bin                                       # Make `go install`ed binaries just work
export PATH=$PATH:`yarn global bin`                                 # Globally installed node things
export PATH=$PATH:/usr/local/heroku/bin                             # Added by the Heroku Toolbelt
export PATH=$PATH:/Users/jwalker/Library/Android/sdk/platform-tools # Android tools

# Hook to make local changes
[ -f ~/.zshrc_local ] && . ~/.zshrc_local || true
