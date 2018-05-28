#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install curl -y
    ;;

  Darwin*)
    # brew install curl
    # echo 'PATH="/usr/local/opt/curl/bin:$PATH"' >> ~/.profile
    # CURL is preinstalled with XCode Tools
    log_info "Skipping curl for MacOS due it's already installed"
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac
