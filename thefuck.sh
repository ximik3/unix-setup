#!/bin/bash

sudo apt-get install python3-dev python3-pip -y
pip3 install --upgrade pip
pip install --user thefuck
thefuck -a
