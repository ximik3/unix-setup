#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install wget -y
    ;;

  Darwin*)
    brew install wget
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

