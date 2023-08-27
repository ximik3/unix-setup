#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME='gs-cli'

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  gsutil version &> /dev/null && exit || exit 1
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  brew install google-cloud-sdk
  if ! grep 'google-cloud-sdk' ~/.zshrc &> /dev/null; then
    echo 'source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"'
    echo 'if command -v gsutil &> /dev/null; then
  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi' >> ~/.zshrc
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  brew uninstall google-cloud-sdk
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