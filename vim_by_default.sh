#!/bin/bash

# Set VIM as default editor
if [ ! -f ~/.profile ]; then
  touch ~/.profile
fi
if [[ -z $(grep 'EDITOR=' ~/.profile) ]]; then
  echo 'EDITOR="vim"' >> ~/.profile
fi
