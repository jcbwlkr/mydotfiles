#!/bin/bash

# Install dependencies
function installPackage() {
    local package=$1
    echo "** Installing package ${package} **"
    if [ "x"$(which apt-get 2>/dev/null) != "x" ]; then
        sudo apt-get --assume-yes install $package
    elif [ "x"$(which yum 2>/dev/null) != "x" ]; then
        sudo yum --assumeyes install $package
    fi
}
dependencies=( git vim tmux python-pip rubygems ctags gnome-python2-gconf )
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

# Add solarized colors to my terminal if the profile isn't configured yet
if [ ! -e ~/.gconf/apps/gnome-terminal/profiles/Solarized ]; then
    git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.local/share/gnome-terminal-colors-solarized
    cd ~/.local/share/gnome-terminal-colors-solarized
    ./solarize
    cd -
fi
