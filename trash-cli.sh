#!/bin/bash

sudo apt-get install trash-cli -y

[[ -z $(grep trash ~/.zshrc) ]] && echo "alias rm='trash'" >> ~/.zshrc || echo 'Skipping... Seems like alias already assigned.'
