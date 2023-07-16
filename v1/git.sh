#!/bin/bash

source platform
source prettyecho
source dots

case $PLATFORM in
  Debian*)
    # sudo apt-get install git -y
    ;;

  Darwin*)
    brew install git
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

setup_dotfile git/gitconfig
