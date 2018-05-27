#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install curl -y
    ;;

  Darwin*)
    brew install curl
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac
