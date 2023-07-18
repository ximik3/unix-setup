#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install trash-cli -y
    ;;

  Darwin*)
    brew install trash-cli
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac


[[ -z $(grep trash ~/.zshrc) ]] && echo "alias rm='trash'" >> ~/.zshrc || echo 'Skipping... Seems like alias already assigned.'
