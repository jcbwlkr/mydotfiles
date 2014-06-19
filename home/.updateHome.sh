#!/bin/bash

# Install dependencies
function installPackage() {
    local package=$1
    local yum_package="${package}"
    local apt_package="${package}"
    if [[ $package == *"|"* ]]; then
        yum_package=$(echo $package | cut -d"|" -f1)
        apt_package=$(echo $package | cut -d"|" -f2)
    fi
    # If the package name includes a | then the name before the | is for yum
    # and the name after is for apt-get
    echo "** Installing package ${package} **"
    return 0
    if [ "x"$(which apt-get 2>/dev/null) != "x" ]; then
        sudo apt-get --assume-yes install $apt_package
    elif [ "x"$(which yum 2>/dev/null) != "x" ]; then
        sudo yum --assumeyes install $yum_package
    fi
}
dependencies=( git "gvim|vim-gnome" tmux rubygems ctags )
for i in "${dependencies[@]}"; do
    installPackage $i
done;

sudo gem install tmuxinator
sudo gem install homesick

# Get homesick castles
homesick clone git@github.com:jacobwalker0814/mydotfiles.git
homesick pull --force --all
homesick symlink mydotfiles
