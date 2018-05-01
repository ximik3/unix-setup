#!/bin/bash

source prettyecho

# Check existing zsh install
CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
  log_error "${YELLOW}Zsh is not installed!${RESET} Please install zsh first!\n"
  exit
fi
unset CHECK_ZSH_INSTALLED

# Clone from GitHub
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Backup .zshrc
printf "${BLUE}Looking for an existing ~/.dotfiles zsh config...${NORMAL}\n"
if [ -f ~/.dotfiles/zshrc ] || [ -h ~/.dotfiles/zshrc ]; then
  printf "${YELLOW}Found ~/.dotfiles/zshrc.${NORMAL} ${GREEN}Backing up to ~/.dotfiles/zshrc.pre-oh-my-zsh${NORMAL}\n";
  mv ~/.dotfiles/zshrc ~/.dotfiles/zshrc.pre-oh-my-zsh;
fi  

cp oh-my-zsh/zshrc ~/.dotfiles/zshrc
