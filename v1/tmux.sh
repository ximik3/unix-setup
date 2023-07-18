#!/bin/bash

source platform
source prettyecho
source dots

case $PLATFORM in
  Debian*)
    sudo apt-get install tmux -y
    ;;

  Darwin*)
    brew install tmux
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

setup_dotfile tmux/tmux.conf
