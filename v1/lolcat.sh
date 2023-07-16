#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install -y fortune cowsay lolcat
    ;;

  Darwin*)
    brew install fortune cowsay lolcat
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

if [[ -z $(grep lolcat ~/.bashrc) ]]; then
  echo '[ -x /usr/games/cowsay -a -x /usr/games/fortune -a -x /usr/games/lolcat ] && \
  fortune | cowsay -f `ls /usr/share/cowsay/cows/ | shuf -n 1` | lolcat' >> ~/.bashrc
fi
if [[ -z $(grep lolcat ~/.zshrc) ]]; then
  echo '[ -x /usr/games/cowsay -a -x /usr/games/fortune -a -x /usr/games/lolcat ] && \
  fortune | cowsay -f `ls /usr/share/cowsay/cows/ | shuf -n 1` | lolcat' >> ~/.zshrc
fi
