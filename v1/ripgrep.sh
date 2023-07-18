#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb
    sudo dpkg -i ripgrep_0.8.1_amd64.deb
    rm ripgrep_0.8.1_amd64.deb
    ;;

  Darwin*)
    brew install ripgrep
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

