#!/bin/bash

source platform
source prettyecho
source dots

case $PLATFORM in
  Debian*)
    sudo apt-get install zsh -y
    ;;

  Darwin*)
    brew install zsh
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

setup_dotfile zsh/zshrc
