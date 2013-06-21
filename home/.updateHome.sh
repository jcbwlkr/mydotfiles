#!/bin/bash

# Install dependencies
function installPackage() {
    local package=$1
    echo "** Installing package ${package} **"
    if [ $(which apt-get 2>/dev/null) != "" ]; then
        sudo apt-get --assume-yes install $package
    elif [ $(which yum 2>/dev/null) != "" ]; then
        sudo yum --assumeyes install $package
    fi
}
dependencies=( git vim tmux python-pip rubygems ctags )
for i in "${dependencies[@]}"; do
    installPackage $i
done;

# Powerline
if [ $(which pip) != "" ]; then
    pip install --user git+git://github.com/Lokaltog/powerline
elif [ $(which python-pip) != "" ]; then
    python-pip install --user git+git://github.com/Lokaltog/powerline
fi

sudo gem install tmuxinator
sudo gem install homesick

# Get homesick castles
homesick clone git@github.com:jacobwalker0814/mydotfiles.git
homesick pull --force --all
homesick symlink mydotfiles

# spf13-vim
sh <( curl http://bit.ly/jacobwalker0814-spf13-vim -L )
