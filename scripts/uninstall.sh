#!/bin/bash

# Remove Oh My Zsh
if [ -x "$HOME/.oh-my-zsh/tools/uninstall.sh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes "$HOME/.oh-my-zsh/tools/uninstall.sh"
fi

# Remove symlinks (only if they are symlinks)
[ -L "$HOME/.zshrc" ] && rm "$HOME/.zshrc"
[ -L "$HOME/.config/nvim" ] && rm "$HOME/.config/nvim"
[ -L "$HOME/.fonts" ] && rm "$HOME/.fonts"

echo "User-level uninstall complete."

sudo apt remove -y zsh zsh-common
sudo apt autoremove -y

rm -rf .oh-my-zsh
rm -rf .zcompdump*
rm -rf .zsh*
