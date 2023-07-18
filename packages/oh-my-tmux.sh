#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="oh-my-tmux"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=(~/.tmux.conf.local)

# Imports
source src/prettyecho

# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed of fails otherwise
already_installed() {
  command -v tmux &>/dev/null &&
    [ -d ~/.tmux ] && [ -e ~/.tmux.conf ] && [ -e ~/.tmux.conf.local ]
}

# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."

  if command -v tmux &>/dev/null; then
    log_info "$(bold tmux) already installed."
  else
    log_info "$(bold tmux) is not installed, installing..."
    brew install tmux
  fi

  if [ -d ~/.tmux ]; then
    log_info "$(bold '~/.tmux') directory already exists."
  else
    log_info "$(bold '~/.tmux') directory is not found, fetching..."
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux
  fi

  if [ -L ~/.tmux.conf ]; then
    log_info "$(bold '~/.tmux.conf') link already exists."
    local TC_DEST=$(ls -l ~/.tmux.conf | tr ' ' '\n' | tail -n1)

    if [ $TC_DEST == "$HOME/.tmux/.tmux.conf" ]; then
      log_info "$(bold '~/.tmux.conf') is linked properly."
    else
      log_info "$(bold '~/.tmux.conf') linked to a wrong location, relinking..."
      ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    fi
  else
    log_info "$(bold '~/.tmux.conf') link is not found, linking..."
    # Linking main config (should newer be changed, only updated via git pull from ~/.tmux)
    ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
  fi

  # Copying customizable config file
  cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

  # Installing required plugins to enable system clipboard interaction
  brew install reattach-to-user-namespace

}

# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  rm -rf ~/.tmux.conf ~/.tmux.conf.local ~/.tmux
  brew uninstall tmux
  brew uninstall reattach-to-user-namespace ||
    log_info "Dependency $(bold reattach-to-user-namespace) is not installed"
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
