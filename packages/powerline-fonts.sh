#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="powerline-fonts"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  ls ~/Library/Fonts/*Powerline* &>/dev/null
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  git clone https://github.com/powerline/fonts.git --depth=1 powerline_fonts &&
    cd powerline_fonts &&
    ./install.sh &&
    cd .. &&
    rm -rf powerline_fonts
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  git clone https://github.com/powerline/fonts.git --depth=1 powerline_fonts &&
    cd powerline_fonts &&
    ./uninstall.sh &&
    cd .. &&
    rm -rf powerline_fonts
}

# Returns a list of configuration files that should be liked with .dotfiles repo
configuration_files() {
  echo "${CONFIGURATION_FILES[@]}"
}

main() {
  case $1 in
  already_installed*) already_installed ;;
  install*) install ;;
  uninstall*) uninstall ;;
  configuration_files*) configuration_files ;;
  *)
    echo "Command is missing or wrong. One of 'already_installed' 'install' 'uninstall' 'configuration_files' command is expected!"
    exit 1
    ;;
  esac
}

main "$@"
