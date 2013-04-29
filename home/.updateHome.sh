#!/bin/bash

# Install dependencies
function installPackage() {
    local package=$1
    echo "** Installing package ${package} **"
    if [ $(which apt-get) != "" ]; then
        sudo apt-get --assume-yes install $package
    elif [ $(which yum) != "" ]; then
        sudo yum --assumeyes install $package
    fi
}
dependencies=( git vim tmux python-pip rubygems ctags )
for i in "${dependencies[@]}"; do
    installPackage $i
done;

# Install homeshick
wget -O - 'https://raw.github.com/andsens/homeshick/master/install.sh' | bash

# Get homeshick castles
$HOME/.homeshick --batch clone git@github.com:jacobwalker0814/mydotfiles.git
$HOME/.homeshick --batch --force pull
$HOME/.homeshick --force symlink

# spf13-vim
sh <( curl http://bit.ly/VwL2wR -L )

# Powerline
if [ $(which pip) != "" ]; then
    pip install --user git+git://github.com/Lokaltog/powerline
elif [ $(which python-pip) != "" ]; then
    python-pip install --user git+git://github.com/Lokaltog/powerline
fi

# Tmuxinator
sudo gem install tmuxinator
