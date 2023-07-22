#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="coursier"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  command -v cs &>/dev/null
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  brew install coursier/formulas/coursier
  if [ "$?" -eq 0 ]; then
    if [ ${PATH#*Coursier/bin} != $PATH ]; then # if coursier binaries are in PATH
      cs setup
    else
      printf 'n\n' | cs setup # fire 'n' to add binaries dialog
      echo 'export PATH="$HOME/Library/Application Support/Coursier/bin:$PATH"' >>~/.zshrc
    fi
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  brew uninstall coursier/formulas/coursier
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
