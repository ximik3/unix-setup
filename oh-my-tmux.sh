#!/bin/bash

source prettyecho
source dots

# Check existing install
if [ -d ~/.tmux ]; then
  log_info 'Found existing .oh-my-tmux installation. Skipping...'
  exit 0
fi

# Clone from git
git clone https://github.com/gpakosz/.tmux.git ~/.tmux

# Backup original .tmux.conf if exist
if [ -f ~/.tmux.conf ]; then
  mv -f ~/.tmux.conf ~/.tmux.conf.pre_oh-my-tmux
fi

# Link oh-my-tmux conf
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf

# Setup custom config file
setup_dotfile oh-my-tmux/tmux.conf.local
