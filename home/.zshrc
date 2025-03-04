###################
# Begin OH MY ZSH #
###################

# Path to your oh-my-zsh configuration.
export DISABLE_UPDATE_PROMPT=true
ZSH=$HOME/.oh-my-zsh

DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rvm docker)

source $ZSH/oh-my-zsh.sh

#################
# End OH MY ZSH #
#################

source $HOME/.zshrc_prompt  # Style my prompt
source $HOME/.zshrc_funcs   # Some useful homemade functions
source $HOME/.zshrc_aliases # Define some aliases

export EDITOR=vim


# Use the default gopath but explicitly set it because some tools expect it
export GOPATH=$(go env GOPATH)

# Don't try to validate private udacity modules
export GOPRIVATE=github.com/udacity

# Define customizations to $PATH
export PATH=$PATH:$GOPATH/bin                                       # Make `go install`ed binaries just work
export PATH=$PATH:$HOME/bin:$HOME/.local/bin                        # Local binaries I might make
#export PATH=$PATH:$(yarn global bin)                                # Globally installed node things
#export PATH=$PATH:/Users/jwalker/Library/Android/sdk/platform-tools # Android tools

# Hook to make local changes
[ -f ~/.zshrc_local ] && . ~/.zshrc_local || true

# Remove duplicates from PATH. Found on StackOverflow:
# https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command/149054#149054
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

#########################################################################################
# Load nvm
#########################################################################################
# Loading nvm was taking 5+ seconds every time I open a shell (which I do
# often) so I'm using this lazy loading approach.
#########################################################################################
lazy_load_nvm() {
  unset -f node nvm npm
  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
}

nvm() {
  lazy_load_nvm
  nvm $@
}

node() {
  lazy_load_nvm
  node $@
}

npm() {
  lazy_load_nvm
  npm $@
}

# Load rbenv if it's installed
eval "$(hash rbenv && rbenv init - zsh)"
export PATH="/usr/local/opt/postgresql@12/bin:$PATH"
