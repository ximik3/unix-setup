#!/bin/bash

wget https://downloads.gradle.org/distributions/gradle-4.7-bin.zip
sudo mkdir /opt/gradle
sudo unzip -d /opt/gradle gradle-4.7-bin.zip
rm gradle-4.7-bin.zip

if [[ -z $(grep 'GRADLE_HOME' ~/.profile) ]]; then
  echo 'GRADLE_HOME=/opt/gradle/gradle-4.7/bin' >> ~/.profile
  echo 'PATH=$PATH:$GRADLE_HOME' >> ~/.profile
fi
