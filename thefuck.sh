#!/bin/bash

sudo apt-get install python3-pip -y
pip3 install --user thefuck
thefuck -a

if [[ -z $(grep 'thefuck --alias' ~/.bashrc) ]]; then
  echo 'eval $(thefuck --alias)' >> ~/.bashrc
fi
if [[ -z $(grep 'thefuck --alias' ~/.zshrc) ]]; then
  echo 'eval $(thefuck --alias)' >> ~/.zshrc
fi
