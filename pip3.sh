#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install python3-pip -y
    ;;

  Darwin*)
    brew install python3
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac
