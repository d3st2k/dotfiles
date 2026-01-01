#!/usr/bin/env bash

export ZSH_CUSTOM="$HOME/dotfiles/configs/zsh/custom"

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

# Install general packages
sudo apt update
sudo apt -y install snapd curl git lua5.4

# Install Neovim v0.11
sudo snap install nvim --classic

# Create symlinks to point to repo
ln -sf ~/dotfiles/configs/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/configs/nvim ~/.config/nvim
ln -sf ~/dotfiles/configs/fonts ~/.fonts

# Change SHELL to ZSH
sudo apt -y install zsh
RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # Install Oh-My-Zsh

# Add ZSH Plugins
while read -r repo; do
  git clone "$repo" "$ZSH_CUSTOM/plugins/$(basename "$repo" .git)"
done <"$ZSH_CUSTOM/plugins/plugins.list"

# Refresh the terminal
fc-cache -fv # Refresh fonts
sudo apt autoremove
sudo chsh -s $(which zsh)

echo "Close the terminal to refresh everything ..."
