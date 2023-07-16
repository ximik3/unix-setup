#!/bin/bash

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

source src/prettyecho
# A check of whether current package is already installed in a system
# Expected to success if package is installed of fail otherwise
already_installed() {
  command -v jenv &> /dev/null
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold jenv) ..."
  brew install jenv
  if grep 'jenv init -' ~/.zshrc &> /dev/null; then
    log_info "Skipping. $(bold jenv) configuration already present in ~/.zshrc"
  else
    log_info "Adding $(bold jenv) configuration to ~/.zshrc"
    # shellcheck disable=SC2016
    echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
    # shellcheck disable=SC2016
    echo 'eval "$(jenv init -)"' >> ~/.zshrc
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold jenv) ..."
  brew uninstall jenv
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