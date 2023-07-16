#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="oh-my-zsh"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=(~/.zshrc)

source src/prettyecho
# A check of whether current package is already installed in a system
# Expected to success if package is installed of fail otherwise
already_installed() {
  [ -d ~/.oh-my-zsh ] && exit 0 || exit 1
}

# An installation process must be implemented here
install() {
  echo "Installing $PACKAGE_NAME ..."
  # Need to remove `exec zsh -l` line from an installation script before run to prevent opening new shell
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed 's/exec zsh -l//g')"
  chmod 755 /usr/local/share/zsh
  chmod 755 /usr/local/share/zsh/site-functions
}

# An uninstallation process should be implemented here
uninstall() {
  echo "Uninstalling $PACKAGE_NAME ..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/uninstall.sh)"
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
