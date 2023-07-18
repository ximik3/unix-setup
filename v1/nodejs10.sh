#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y nodejs
    ;;

  Darwin*)
    brew install node@10
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

