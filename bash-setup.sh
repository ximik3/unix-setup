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
    ln -s ~/.bash_profile ~/.bashrc
  fi
fi
if [ -f ~/.profile ]; then
  echo 'Backing up original .profile -> .profile.old'
  mv ~/.profile ~/.profile.old
fi
setup_dotfile bash/profile
if [[ -z $(grep 'source ~/.profile' ~/.bashrc) ]]; then
  echo '# Source ~/.profile if exists' >> ~/.bashrc
  echo 'if [ -f ~/.profile ]; then' >> ~/.bashrc
  echo '  source ~/.profile' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
fi
