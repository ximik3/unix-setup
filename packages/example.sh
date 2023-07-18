#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="example"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  log_warning "Installation check is not implemented for $(bold $PACKAGE_NAME)!"
  exit 126
  # command -v <example> &> /dev/null
}

# An installation process must be implemented here
install() {
  log_warning "Installation process is not implemented for $(bold $PACKAGE_NAME)!"
  exit 126
  # log_info "Installing $(bold $PACKAGE_NAME) ..."
}

# An uninstallation process should be implemented here
uninstall() {
  log_warning "Uninstall process is not implemented for $(bold $PACKAGE_NAME)!"
  exit 126
  # log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
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