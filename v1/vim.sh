#!/bin/bash

source platform
source prettyecho
source dots

case $PLATFORM in
  Debian*)
    sudo apt-get install vim-gtk3 -y
    ;;

  Darwin*)
    log_info 'Skipping vim installation for MacOS (Preinstalled)'
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

setup_dotfile vim/vimrc
