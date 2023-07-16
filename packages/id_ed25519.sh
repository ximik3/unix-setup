#!/bin/bash

PACKAGE_FILE_PATH=$HOME/.ssh/id_ed25519

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  [ -e "$PACKAGE_FILE_PATH" ]
}

# An installation process must be implemented here
install() {
  echo $PACKAGE_FILE_PATH
  if already_installed; then
    log_error "$(bold "$PACKAGE_FILE_PATH") is already present!"
    exit 1
  else
    read -rp "Enter email used for id_ed25519: " USEREMAIL
    log_info "Creating $(bold "$PACKAGE_FILE_PATH") ..."
    echo -e "\n" | ssh-keygen -t ed25519 -C "$USEREMAIL" -N ''
    if [ -e ~/.ssh/config ] && grep '.ssh/id_ed25519' ~/.ssh/config &>/dev/null; then
      log_warning "~/.ssh/config already mentions ~/.ssh/id_ed25519 key, skipping!"
    else
      log_info "Adding GitHub and GitLab configurations to ~/.ssh/config"
      cat >>~/.ssh/config <<EOL

Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519

Host gitlab.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOL
      log_warning "Now you need to add public key $(bold ~/.ssh/id_ed25519) to your GitHub or GitLab accounts"
      log_warning "Run $(bold 'pbcopy < ~/.ssh/id_ed25519.pub') and paste it to GitHub or GitLab SSH Keys page"
    fi
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Deleting $(bold $PACKAGE_FILE_PATH) ..."
  rm $PACKAGE_FILE_PATH*
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
