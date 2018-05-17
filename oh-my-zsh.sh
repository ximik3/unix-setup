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
  mv -f ~/.dotfiles/zshrc ~/.dotfiles/zshrc.pre-oh-my-zsh;
else
  printf "${BLUE}No existing ~/.dotfiles/zshrc found${NORMAL}";
fi
printf "${BLUE}Looking for an existing ~/.zshrc config...${NORMAL}\n"
if [ -f ~/.zshrc ]; then
  printf "${YELLOW}Found ~/.zshrc.${NORMAL} ${GREEN}Backing up to ~/.zshrc.pre-oh-my-zsh${NORMAL}\n";
  mv -f ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
else
  printf "${BLUE}No existing ~/.zshrc found${NORMAL}";
fi

cp oh-my-zsh/zshrc ~/.dotfiles/zshrc
ln -s ~/.dotfiles/zshrc ~/.zshrc
