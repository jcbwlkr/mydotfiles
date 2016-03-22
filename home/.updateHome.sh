#!/bin/bash -ex

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
    if [ "x"$(which apt-get 2>/dev/null) != "x" ]; then
        sudo apt-get --assume-yes install $apt_package
    elif [ "x"$(which yum 2>/dev/null) != "x" ]; then
        sudo yum --assumeyes install $yum_package
    fi
}
# TODO homebrew
# ack
dependencies=( git "gvim|vim-gnome" tmux ctags zsh )
for i in "${dependencies[@]}"; do
    installPackage $i
done;

# Install oh-my-zsh
wget -q --no-check-certificate http://install.ohmyz.sh -O - | sh

# Install ruby via rvm
curl -sSL https://get.rvm.io | bash -s stable --ruby
source $HOME/.rvm/scripts/rvm
rvm reload

gem install tmuxinator
gem install homesick

# Get homesick castles
homesick clone git@github.com:jcbwlkr/mydotfiles.git
homesick pull --force --all
homesick symlink mydotfiles

# Install composer and global requirements
mkdir $HOME/bin
curl -s https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer
$HOME/bin/composer global install

cd $HOME/.composer/vendor/techlivezheng/phpctags
make
mv build/phpctags.phar $HOME/.composer/vendor/bin/phpctags
