#!/bin/bash

wget https://github.com/djui/alias-tips/archive/master.zip
unzip master.zip
echo 'Moving alias-tips plugin to $ZSH/custom folder'
mv alias-tips-master ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips || rm -r alias-tips-master
rm master.zip

if [[ -z $(grep 'alias-tips' ~/.zshrc) ]]; then
  echo 'Adding alias-tips to oh-my-zsh plugin list...'
  echo 'plugins+=(... alias-tips)' >> ~/.zshrc
else
  echo 'Found existing alias-tips record in ~/.zshrc.'
fi
