#!/bin/bash

# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
#./uninstall.sh - for uninstall
# clean-up a bit
cd ..
rm -rf fonts

# Set current terminal font
#gsettings set org.gnome.desktop.interface monospace-font-name 'Hack 10'
