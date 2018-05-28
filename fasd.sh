#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo add-apt-repository ppa:aacebedo/fasd -y
    sudo apt-get update
    sudo apt-get install fasd -y
    ;;

  Darwin*)
    brew install fasd
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

if [[ -z $(grep fasd ~/.bashrc) ]]; then
  echo 'eval `fasd --init auto`' >> ~/.bashrc
fi
if [[ -z $(grep fasd ~/.zshrc) ]]; then
  echo 'eval `fasd --init auto`' >> ~/.zshrc
fi
