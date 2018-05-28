#!/bin/bash

source platform
source prettyecho

case $PLATFORM in
  Debian*)
    if [ -d /opt/gradle/gradle-4.7 ]; then
      log_info 'Found existing gradle-4.7 installation. Skipping...'
      exit 0
    fi

    wget https://downloads.gradle.org/distributions/gradle-4.7-bin.zip
    sudo mkdir /opt/gradle
    sudo unzip -d /opt/gradle gradle-4.7-bin.zip
    rm gradle-4.7-bin.zip
    ;;

  Darwin*)
    brew install gradle
    ;;

  *)
    log_error "Platform not supported"
    exit 1
    ;;

esac

# TODO: Fix MacOS GRADLE_HOME variable
# .profile should remain platform independent
if [[ -z $(grep 'GRADLE_HOME' ~/.profile) ]]; then
  echo 'case $(uname -s) in' >> ~/.profile
  echo '  Linux*)' >> ~/.profile
  echo '    GRADLE_HOME=/opt/gradle/gradle-4.7/bin' >> ~/.profile
  echo '    PATH=$PATH:$GRADLE_HOME' >> ~/.profile
  echo '    ;;' >> ~/.profile
  echo '  Darwin*)' >> ~/.profile
  echo '    GRADLE_HOME=/usr/local/Cellar/gradle/4.7/bin' >> ~/.profile
  echo '    ;;' >> ~/.profile
  echo 'esac' >> ~/.profile
fi


