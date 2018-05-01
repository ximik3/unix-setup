#!/bin/bash

wget https://github.com/djui/alias-tips/archive/master.zip
unzip master.zip
mv alias-tips-master ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips || rm -r alias-tips-master 
rm master.zip

if [[ -z $(grep 'alias-tips' ~/.zshrc) ]]; then
  echo 'plugins+=(... alias-tips)' >> ~/.zshrc
fi 
