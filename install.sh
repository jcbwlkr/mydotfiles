#!/bin/sh

# Install script for mydotfiles
# Sections:
#   Install dependencies
#   Optionally install other utilities
#   Link dotfiles into place

myInstall () {
    echo "You asked to install $1";
}

myLink () {
    # $1 is source file
    # $2 is new destination

    # If there's already a link there just unlink it
    [ -L $2 ] && unlink $2
    # If there's a real file there then back it up
    [ -e $2 ] && mv $2 $2.$backupExtension
    # Make symlink
    ln --symbolic $1 $2
}

installDir=$(dirname $(readlink -fn $0))
backupExtension=`date +%s`.bak

echo -n "Do you want to install optional utilities like mysql, php5 etc? (y/n): "
read includeOptional

# Section 1: Dependecies
myInstall "git"
myInstall "curl"
myInstall "vim"
myInstall "screen"
# Install extended vim configuration
# sh <(curl http://bit.ly/VwL2wR -L )
# fonts

# Section 2: Optional utilities

# Section 3: Dotfiles
myLink $installDir/screen/.screenrc $HOME/.screenrc
myLink $installDir/bash/.bashrc $HOME/.bashrc
myLink $installDir/bash/.bash_aliases $HOME/.bash_aliases
myLink $installDir/bash/.bash_ps1 $HOME/.bash_ps1
myLink $installDir/vim/.vimrc.local $HOME/.vimrc.local
myLink $installDir/vim/.vimrc.bundles.local $HOME/.vimrc.bundles.local
