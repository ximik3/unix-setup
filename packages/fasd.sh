#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="fasd"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  command -v fasd &>/dev/null
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."

  git clone git@github.com:ximik3/fasd.git || exit 1 # if it is not cloned - no reason to continue
  local CURDIR=$(pwd)
  cd fasd && make install
  cd $CURDIR && rm -rf fasd # cleanup

  if ! grep 'fasd' ~/.zshrc; then
    log_info "Adding init script to ~/.zshrc"
    echo 'PLUGINS+=(fasd)"' >> ~/.zshrc
  else
    log_info "~/.zshrc already contains init script"
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  git clone git@github.com:ximik3/fasd.git || exit 1 # if it is not cloned - no reason to continue
  local CURDIR=$(pwd)
  cd fasd && make uninstall
  cd $CURDIR && rm -rf fasd # cleanup
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