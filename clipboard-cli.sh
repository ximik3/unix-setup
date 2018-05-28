#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install xclip xsel -y
    ;;

  Darwin*)
    log_info "Skipping clipboard-cli install for MacOS (native alternative pbcopy)"
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

