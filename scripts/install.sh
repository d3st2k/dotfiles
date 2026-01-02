#!/usr/bin/env bash

# Clone the repository in the $HOME dir
cd

# Choose between SSH & HTTPS PROTOCOL
[[ -n "$PROTOCOL" ]] || PROTOCOL="HTTPS"
if [[ $PROTOCOL = "HTTPS" ]]; then
  git clone https://github.com/d3st2k/dotfiles.git
elif [[ $PROTOCOL = "SSH" ]]; then
  git clone git@github.com:d3st2k/dotfiles.git
else
  echo "$PROTOCOL is not supported!!"
fi

# Update & Install general packages
sudo apt update
sudo apt -y install snapd curl git lua5.4

# Install external packages
lua $HOME/dotfiles/scripts/packages/ide/nvim.lua
lua $HOME/dotfiles/scripts/packages/shell/zsh.lua

# Create symlinks to point to repo
ln -sf $HOME/dotfiles/configs/fonts ~/.fonts

# Refresh fonts
fc-cache -fv

# Remove unnecessary packages
sudo apt autoremove

echo "Close the terminal to refresh everything ..."
