#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    sudo apt-get install openjdk-8-jdk -y
    ;;

  Darwin*)
    brew tap caskroom/versions
    brew cask install java8
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

# .profile should remain platform independent
if [[ -z $(grep 'JAVA_HOME' ~/.profile) ]]; then
  echo 'case $(uname -s) in' >> ~/.profile
  echo '  Linux*) JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 ;;' >> ~/.profile
  echo '  Darwin*) JAVA_HOME=`/usr/libexec/java_home -v 1.8` ;;' >> ~/.profile
  echo 'esac' >> ~/.profile
fi
