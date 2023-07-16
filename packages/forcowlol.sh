#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="forcowlol"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=""

source src/prettyecho
# A check of whether current package is already installed in a system
# Expected to success if package is installed of fail otherwise
already_installed() {
  command -v fortune &>/dev/null &&
    command -v cowsay &>/dev/null &&
    command -v lolcat &>/dev/null
}

# An installation process must be implemented here
install() {
  brew install fortune cowsay lolcat
  if [ ! -f ~/.zshrc ]; then
    log_warning "~/.zshrc is not found and can't be updated"
  elif grep 'fortune | cowsay -f' ~/.zshrc &>/dev/null; then
    log_warning "~/.zshrc is already updated"
  else
    echo '[ -x /usr/local/bin/cowsay -a -x /usr/local/bin/fortune -a -x /usr/local/bin/lolcat ] && \
    fortune | cowsay -f `cowsay -l | tail -n +2 | tr " " "\n" | perl -MList::Util=shuffle -e "print shuffle <STDIN>" | head -n1` | lolcat' >> ~/.zshrc
  fi
}

# An uninstallation process should be implemented here
uninstall() {
  brew uninstall fortune &&
    brew uninstall cowsay &&
    brew uninstall lolcat
}

# Returns a list of configuration files that should be liked with .dotfiles repo
configuration_files() {
  echo "$CONFIGURATION_FILES"
}

main() {
  case $1 in
  already_installed*) already_installed ;;
  install*) install ;;
  uninstall*) uninstall ;;
  configuration_files*) configuration_files ;;
  *)
    echo "Command is missing or wrong! One of 'already_installed' 'install' 'uninstall' 'configuration_files' command is expected!"
    exit 1
    ;;
  esac
}

main "$@"
