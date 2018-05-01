#!/bin/bash

sudo apt-get install tmux -y
if [ ! -d ~/.dotfiles ]; then
  mkdir -p ~/.dotfiles
fi
if [ ! -f ~/.tmux.conf -a -f tmux/tmux.conf ]; then
  cp tmux/tmux.conf ~/.dotfiles/
  ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
fi
