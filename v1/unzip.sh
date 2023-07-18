#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install unzip -y
    ;;

  Darwin*)
    log_info "Skipping unzip for macOS (Already Installed)"
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac
