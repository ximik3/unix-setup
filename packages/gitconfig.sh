#!/bin/bash

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=(~/.gitconfig)

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  [ -e ~/.gitconfig ]
}

# An installation process must be implemented here
install() {
  if already_installed; then
    log_error "$(bold ~/.gitconfig) is already present!"
    exit 1
  else
    read -rp "Enter git config user.name: " USERNAME
    read -rp "Enter git config user.email: " USEREMAIL
    log_info "Creating $(bold ~/.gitconfig) ..."
    cat > ~/.gitconfig << EOL
[user]
    name = $USERNAME
    email = $USEREMAIL
[pull]
    rebase = false
EOL
  fi
}

# An uninstallation process should be implemented here
uninstall() {
   log_info "Deleting $(bold ~/.gitconfig) ..."
   rm -rf ~/.gitconfig
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
