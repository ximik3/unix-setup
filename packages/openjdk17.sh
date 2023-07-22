#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME='openjdk@17'  # TODO: replace with package name (`brew install <package-name>`)

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  [ -d /usr/local/Cellar/openjdk@17 ]
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  brew install openjdk@17
  sudo ln -sfn /usr/local/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  brew uninstall openjdk@17
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