#!/bin/bash

# Clone from git
git clone https://github.com/gpakosz/.tmux.git
if [ -d ~/.tmux ]; then
  rm -rf ~/.tmux
  mv .tmux ~/.tmux
fi
rm -rf .tmux

# Backup original .tmux.conf if exist
if [ -f ~/.tmux.conf ]; then
  mv -f ~/.tmux.conf ~/.tmux.conf.pre_oh-my-tmux
fi

# Link oh-my-tmux conf
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
cp ~/.tmux/.tmux.conf.local ~

# Replace with custom config if present
if [ ! -d ~/.dotfiles ]; then
  mkdir -p ~/.dotfiles
fi
if [ ! -f ~/.dodfiles/tmux.conf.local -a -f oh-my-tmux/tmux.conf.local ]; then
  cp oh-my-tmux/tmux.conf.local ~/.dotfiles/
  ln -s -f ~/.dotfiles/tmux.conf.local ~/.tmux.conf.local
fi




