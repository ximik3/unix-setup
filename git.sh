#!/bin/bash

source platform

case $PLATFORM in
  Debian*)
    sudo apt-get install git -y
    ;;
   
  Darwin*)
    brew install git
    ;;
    
esac


if [ ! -d ~/.dotfiles ]; then
  mkdir -p ~/.dotfiles
fi
if [ -f ~/.gitconfig ]; then
  echo "Found existing .gitconfig file. Moving to ~/.dotfiles"
  mv ~/.gitconfig ~/.dotfiles/gitconfig
  ln -s ~/.dotfiles/gitconfig ~/.gitconfig
elif [ -f git/gitconfig ]; then
  echo "Setting up configuration file (~/.gitconfig)"
  cp git/gitconfig ~/.dotfiles/gitconfig
  ln -s ~/.dotfiles/gitconfig ~/.gitconfig
fi
