#!/usr/bin/env bash

# Clone the repository in the $HOME dir
cd 

# Set PROTOCOL to the one that you want to use
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
ln -s ~/dotfiles/configs/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/configs/nvim ~/.config/nvim
ln -s ~/dotfiles/configs/fonts ~/.fonts

# Change SHELL to ZSH
sudo apt -y install zsh
sudo chsh -s $(which zsh) # Set ZSH shell as default
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # Install Oh-My-Zsh

# Reboot
fc-cache -fv # Refresh fonts
echo "Close the terminal to refresh everything ..."
