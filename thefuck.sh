#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install python3-pip -y
    pip3 install --user thefuck
    thefuck -a
    ;;

  Darwin*)
    brew install thefuck
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

if [[ -z $(grep 'thefuck --alias' ~/.bashrc) ]]; then
  echo 'eval $(thefuck --alias)' >> ~/.bashrc
fi
if [[ -z $(grep 'thefuck --alias' ~/.zshrc) ]]; then
  echo 'eval $(thefuck --alias)' >> ~/.zshrc
fi
