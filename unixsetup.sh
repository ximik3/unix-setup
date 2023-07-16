#!/bin/bash

####################################################
# Unix enironment setup				                     #
# @author: Volodymyr Kukhar (ximiksk8er@gmail.com) #
####################################################

# Imports
source src/prettyecho
source src/dotfiles

CANDIDATES=(
  id_ed25519
  gitconfig
  powerline-fonts
  oh-my-zsh
  oh-my-tmux
  vimrc
  jenv
)

SKIPPED=()
INSTALLED=()
FAILED=()

PACKAGES_DIR="./packages"

usage() { # Print usage
  echo "Usage:
  -h        Print help message an exit
  -l        List all available installation packages
  -c        List all candidate packages to be installed with -a option
  -s        Status check: Lookup for already installed packages
  [-e NAME] Check if a specific package exists and its installation status
  [-i NAME] Install a specific package
  [-u NAME] Uninstall a specific package
  -a        Install all candidate packages" 1>&2
}

exit_abnormal() { # Function: Exit with error.
  usage
  return 1
}

existing_package() { # Check if package file exists
  local NAME=$1
  for FILE in $PACKAGES_DIR/*.sh; do
    if [ "$NAME.sh" = "$(basename $FILE)" ]; then
      return 0
    fi
  done
  return 1
}

list_packages() { # Print packages list depending on a provided status
  case $1 in
  skipped)
    printf "$(bold "  %s\n")" "${SKIPPED[@]}"
    ;;
  failed)
    printf "$(bold "  %s\n")" "${FAILED[@]}"
    ;;
  installed)
    printf "$(bold "  %s\n")" "${INSTALLED[@]}"
    ;;
  candidates)
    printf "$(bold "  %s\n")" "${CANDIDATES[@]}"
    ;;
  *)
    printf "$(bold "  %s\n")" $(ls $PACKAGES_DIR | cut -d. -f1)
    ;;
  esac
}

list_installed() {
  for PACKAGE in $PACKAGES_DIR/*.sh; do
    if bash $PACKAGE already_installed; then
      INSTALLED+=($(basename $PACKAGE | cut -d. -f1))
    fi
  done
  local N=${#INSTALLED[@]}
  if [ $N -gt 0 ]; then
    echo "Packages installed on this machine:"
    list_packages installed
  else
    echo "Installed packages not found"
  fi
}

check_package() { # Check if package exists and it's installation status
  local PACKAGE=$1
  if ! existing_package "${PACKAGE}"; then
    echo "Package $(bold "$PACKAGE") is not found!"
  else
    bash "$PACKAGES_DIR/$PACKAGE.sh" already_installed
    local STATUS=$?
    if [ $STATUS -eq 0 ]; then
      echo "Package $(bold "$PACKAGE") is installed!"
    elif [ $STATUS -eq 126 ]; then
      echo "Package $(bold "$PACKAGE") installation status can not be checked!"
    else
      echo "Package $(bold "$PACKAGE") is not installed!"
    fi
  fi
  return
}

request_sudo() { # Request superuser privileges
  sudo echo "Sudo was granted!"
}

install_package() { # Install a package by name
  local PACKAGE=$1

  if ! existing_package "${PACKAGE}"; then
    log_error "Package $(bold "$PACKAGE") is not found!"
    return 1
  fi

  bash "$PACKAGES_DIR/$PACKAGE.sh" already_installed
  local STATUS=$?
  if [ $STATUS -eq 0 ]; then
    log_info "Package $(bold "$PACKAGE") is already installed, skipping..."
    SKIPPED+=("$PACKAGE")
    return 0
  elif [ $STATUS -eq 126 ]; then
    echo "Package $(bold "$PACKAGE") installation status can't be checked!"
    while true; do
      read -rp "Do you want to install it anyway? [Y/n] " yn
      case $yn in
      [Yy]*)
        execute_install "$PACKAGE"
        return $?
        ;;
      [Nn]*)
        echo -e "\nSkipping installation..."
        FAILED+=("$PACKAGE")
        return
        ;;
      *)
        echo "Please provide correct answer"
        ;;
      esac
    done
    return
  else
    execute_install "$PACKAGE"
  fi

}

execute_install() { # Execute installation for a package
  local PACKAGE=$1
  request_sudo
  bash "$PACKAGES_DIR/$PACKAGE.sh" install
  local RESULT=$?
  if [ "$RESULT" -eq 0 ]; then
    log_success "Package $(bold "$PACKAGE") successfully installed"
    INSTALLED+=("$PACKAGE")
    CONF=($(bash "$PACKAGES_DIR/$PACKAGE.sh" configuration_files))
    link_configs "${CONF[@]}"
    return
  elif [ $RESULT -eq 126 ]; then
    log_error "Failed to install $(bold "$PACKAGE") because installation is not implemented"
    log_error "Check $PACKAGES_DIR/$PACKAGE.sh file!"
    FAILED+=("$PACKAGE")
    return 1
  else
    log_error "Failed to install $(bold "$PACKAGE")!"
    FAILED+=("$PACKAGE")
    return 1
  fi
}

link_configs() {
  local CONFIGS=("$@")
  for FILE in "${CONFIGS[@]}"; do
    setup_dotfile "$FILE"
  done
}

uninstall_package() { # Uninstall package by name
  local PACKAGE=$1

  if ! existing_package "${PACKAGE}"; then
    log_error "Package $(bold "$PACKAGE") is not found!"
    exit 1
  fi

  bash "$PACKAGES_DIR/$PACKAGE.sh" already_installed
  local IS_INSTALLED=$?
  if [ "$IS_INSTALLED" -eq 126 ]; then
    echo "Package $(bold "$PACKAGE") installation status can not be checked!"
    while true; do
      read -rp "Do you want to try to uninstall it anyway? [Y/n] " yn
      case $yn in
      [Yy]*)
        request_sudo
        if bash "$PACKAGES_DIR/$PACKAGE.sh" uninstall; then
          log_success "Package $(bold "$PACKAGE") successfully uninstalled!"
          exit
        else
          log_error "Uninstallation failed for $(bold "$PACKAGE")!"
          exit 1
        fi
        ;;
      [Nn]*)
        echo -e "\nSkipping uninstallation..."
        exit
        ;;
      *)
        echo "Please provide correct answer"
        ;;
      esac
    done
  elif [ $IS_INSTALLED -eq 0 ]; then
    log_info "Package $(bold "$PACKAGE") is installed. Uninstalling..."
    if bash "$PACKAGES_DIR/$PACKAGE.sh" uninstall; then
      log_success "Package $(bold "$PACKAGE") successfully uninstalled"
      exit
    else
      log_error "Failed to uninstall $(bold "$PACKAGE")!"
      exit 1
    fi
  else
    log_info "Package $(bold "$PACKAGE") is not installed. Nothing to uninstall. Skipping..."
    exit
  fi

}

install_all_candidates() { # Install all candidate packages
  echo "The following packages are going to be installed:"
  list_packages candidates
  while true; do
    read -rp "Do you want to continue? [Y/n] " yn
    case $yn in
    [Yy]*)
      for PACKAGE in "${CANDIDATES[@]}"; do
        install_package "$PACKAGE"
      done
      if [ ${#INSTALLED[@]} -gt 0 ]; then
        echo "Following packages were successfully installed:"
        list_packages installed
      fi
      if [ ${#FAILED[@]} -gt 0 ]; then
        echo "Following packages failed:"
        list_packages failed
      fi
      if [ ${#SKIPPED[@]} -gt 0 ]; then
        echo "Following packages were skipped:"
        list_packages skipped
      fi
      exit 0
      ;;
    [Nn]*)
      echo -e "\nSkipping installation..."
      exit 0
      ;;
    *) echo "Please provide correct answer" ;;
    esac
  done

  exit 0
}

main() {
  if [ $# -eq 0 ]; then # no args provided
    exit_abnormal
  fi

  while getopts ":hlcse:i:u:a" OPTS; do
    case "${OPTS}" in
    h) # print usage and exit
      usage
      exit
      ;;
    l) # list all packages
      list_packages all
      exit
      ;;
    c) # list all candidates to be installed install with -a option
      list_packages candidates
      exit
      ;;
    s) # list all installed packages
      list_installed
      exit
      ;;
    e) # check if package exists and was installed
      check_package "$OPTARG"
      ;;
    i) # install specified package
      install_package "$OPTARG"
      ;;
    u) # uninstall specified package
      uninstall_package "$OPTARG"
      ;;
    a) # install all candidate packages
      install_all_candidates
      ;;
    *)
      exit_abnormal
      ;;
    esac
  done
}

main "$@"
