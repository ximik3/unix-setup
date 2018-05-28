#!/bin/bash

source platform
source prettyecho
source dots

if [ "$PLATFORM" = "Darwin" ]; then
  if [ ! -f ~/.bash_profile ]; then
    echo 'Creating ~/.bash_profile'
    touch ~/.bash_profile
  fi
  if [ ! -f ~/.bashrc ]; then
    echo 'Linking ~/.bashrc to ~/.bash_profile'
    ln -s ~/.bashrc ~/.bash_profile
  fi
fi
touch profile
setup_dotfile profile
rm profile
if [[ -z $(grep 'source ~/.profile' ~/.bashrc) ]]; then
  echo '# Source ~/.profile if exists' >> ~/.bashrc
  echo 'if [ -f ~/.profile ]; then' >> ~/.bashrc
  echo '  source ~/.profile' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
fi
