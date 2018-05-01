#!/bin/bash

sudo apt-get install vim-gtk3 -y
if [ ! -d ~/.dotfiles ]; then
  mkdir -p ~/.dotfiles
fi
if [ ! -f ~/.vimrc -a -f vim/vimrc ]; then
  cp vim/vimrc ~/.dotfiles/
  ln -s ~/.dotfiles/vimrc ~/.vimrc
fi
