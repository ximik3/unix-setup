#!/bin/bash

# Imports
source platform
source prettyecho
source dots

# Pre-installation scripts
# Platform specific
case $PLATFORM in
  Debian*)
    sudo apt-get update
    ;;

  Darwin*)
    xcode-select --install
    if [[ -z `brew doctor` ]]; then
      /usr/bin/ruby -e \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
        </dev/null
      brew doctor
    else
      log_info "Brew already installed. Skipping..."
    fi
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;
esac
