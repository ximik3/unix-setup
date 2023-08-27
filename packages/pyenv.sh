#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME='pyenv'  # TODO: replace with package name (`brew install <package-name>`)
PACKAGE_CMD="$PACKAGE_NAME" # replace with package command if differs from name

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  command -v $PACKAGE_CMD &> /dev/null
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  brew install $PACKAGE_NAME
  if grep 'pyenv init -' ~/.zshrc &> /dev/null; then
      log_info "Skipping. $(bold $PACKAGE_NAME) configuration already present in ~/.zshrc"
    else
      log_info "Adding $(bold $PACKAGE_NAME) configuration to ~/.zshrc"
      echo 'if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi' >> ~/.zshrc
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  brew uninstall $PACKAGE_NAME
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