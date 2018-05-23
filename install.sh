#!/bin/bash

#################################################
# Unix enironment setup				#
# @author: Volodymyr Koukhar (kyxap@ukr.net)	#
#################################################

# Here you can define what is gonna be installed:
CANDIDATES=(
#> ---- System wide tools ----
git
curl
wget
unzip
clipboard-cli
pip3
nodejs10
gradle47

#> ---- CLI Tools ----
fonts-powerline
zsh
oh-my-zsh
zsh-alias-tips
   # zsh_by_default > requires password input
fasd
fzf
ripgrep
trash-cli
thefuck
lolcat
vim
vim_by_default
tmux
oh-my-tmux

)

# Imports
source prettyecho

# Confirm?
echo "The following packages are going to be installed:"
printf "\033[1m  %s\n\033[0m" "${CANDIDATES[@]}"
while true; do
    read -p "Do you want to continue? [Y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo -e "\nSkipping installation..."; exit;;
	* ) echo "Please provide correct answer";;
    esac
done

# Prompting sudo password
sudo echo "Password prompted!"

# Installation process
NOT_INSTALLED=()
for PACKAGE in ${CANDIDATES[@]}
do
  echo
  log_info "Installing ${BOLD}${PACKAGE}${NORMAL}..."
  bash "${PACKAGE}.sh"
  if [ $? -eq 0 ]; then
    log_success "Package ${BOLD}${PACKAGE}${NORMAL} successfully installed"
  else
    log_error "Failed to install ${BOLD}${PACKAGE}${NORMAL}!"
    NOT_INSTALLED+=(${PACKAGE})
  fi
done

# Finishing
echo -e "\n${BOLD}$((${#CANDIDATES[@]} - ${#NOT_INSTALLED[@]}))${NORMAL} of ${BOLD}${#CANDIDATES[@]}${NORMAL} packages were successfully installed."
if [ ${#NOT_INSTALLED[@]} -ne 0 ]; then
  log_warning "Packages that were not installed:"
  printf "\033[1;31m  %s\n\033[0m" "${NOT_INSTALLED[@]}"
fi
echo "Installation finished."
