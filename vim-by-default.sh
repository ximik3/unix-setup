#!/bin/bash

# Set VIM as default editor
if [[ -z $(grep 'EDITOR=' ~/.profile) ]]; then
  echo 'EDITOR="vim"' >> ~/.profile
fi
