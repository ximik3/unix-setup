#!/bin/bash

# Imports
source platform
source prettyecho
source dots

# Pre-installation scripts
# General
touch profile
setup_dotfile profile
rm profile
if [[ -z $(grep '.profile' ~/.bashrc) ]]; then
  echo 'source ~/.profile' >> ~/.bashrc
fi

# Platform specific
case $PLATFORM in
  Debian*)
    sudo apt-get update
    ;;
  Darwin*)
    xcode-select --install
    /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
      </dev/null
    brew doctor
    ;;
  *)
    log_error "Platform not supported"
    exit 1
    ;;
esac
