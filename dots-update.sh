#!/bin/bash

[ -f ~/.dotfiles/gitconfig ] &&\
  cp -f ~/.dotfiles/gitconfig git/gitconfig || echo "gitconfig not found"
[ -f ~/.dotfiles/vimrc ] &&\
  cp -f ~/.dotfiles/vimrc vim/vimrc || echo "vimrc not found"
[ -f ~/.dotfiles/profile ] &&\
  cp -f ~/.dotfiles/profile bash/profile || echo "profile not found"
[ -f ~/.dotfiles/tmux.conf.local ] &&\
  cp -f ~/.dotfiles/tmux.conf.local oh-my-tmux/tmux.conf.local || echo "tmux.conf.local not found"
[ -f ~/.dotfiles/zshrc ] &&\
  cp -f ~/.dotfiles/zshrc oh-my-zsh/zshrc || echo "zshrc not found"
