#!/bin/bash

sudo apt-get install fortune -y
sudo apt-get install cowsay -y
sudo apt-get install lolcat -y

if [[ -z $(grep lolcat ~/.bashrc) ]]; then
  echo '[ -x /usr/games/cowsay -a -x /usr/games/fortune -a -x /usr/games/lolcat ] && \
  fortune | cowsay -f `ls /usr/share/cowsay/cows/ | shuf -n 1` | lolcat' >> ~/.bashrc
fi
if [[ -z $(grep lolcat ~/.zshrc) ]]; then
  echo '[ -x /usr/games/cowsay -a -x /usr/games/fortune -a -x /usr/games/lolcat ] && \
  fortune | cowsay -f `ls /usr/share/cowsay/cows/ | shuf -n 1` | lolcat' >> ~/.zshrc
fi
