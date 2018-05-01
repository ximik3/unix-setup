#!/bin/bash

sudo apt-get install zsh -y
if [ ! -d ~/.dotfiles ]; then
  mkdir -p ~/.dotfiles
fi
if [ ! -f ~/.zsh_history -a -f zsh/zsh_history ]; then
  cp zsh/zsh_history ~/.dotfiles/zsh_history
  ln -s ~/.dotfiles/zsh_history ~/.zsh_history
fi
if [ ! -f ~/.zshrc -a -f zsh/zshrc ]; then
  cp zsh/zshrc ~/.dotfiles/zshrc
  ln -s ~/.dotfiles/zshrc ~/.zshrc
fi
