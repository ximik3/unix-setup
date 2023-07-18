#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="vimrc"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=(~/.vimrc)

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  [ -e ~/.vimrc ]
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  brew install universal-ctags # dependency for tagbar plugin
  cp resources/vimrc ~/.vimrc
  # Setting default editor - vim
  if ! grep -E -i '^\s*export EDITOR=\W*vim\W*$' ~/.zshrc; then
    echo "export EDITOR='vim'" >> ~/.zshrc
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  rm ~/.vimrc
}

# Returns a list of configuration files that should be liked with .dotfiles repo
configuration_files() {
  echo "${CONFIGURATION_FILES[@]}"
}


main() {
  case $1 in
    already_installed*)   already_installed;;
    install*)             install;;
    uninstall*)           uninstall;;
    configuration_files*) configuration_files;;
    *)
      echo "Command is missing or wrong. One of 'already_installed' 'install' 'uninstall' 'configuration_files' command is expected!"
      exit 1
  esac
}

main "$@"
