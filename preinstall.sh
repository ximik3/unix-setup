#!/bin/bash

# Imports
source platform

# Pre-installation scripts
case "$(uname -s)" in
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
esac
