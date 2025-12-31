# Clone the repository in the $HOME dir
cd 
git clone https://github.com/d3st2k/dotfiles.git

# Install required packages/lang
sudo apt update
sudo apt -y install curl git lua5.4 zsh
sudo chsh -s $(which zsh) # Set ZSH shell as default
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # Install Oh-My-Zsh

# Create symlinks to point to repo
ln -s ~/dotfiles/configs/nvim ~/.config/nvim
ln -s ~/dotfiles/configs/fonts ~/.fonts

# Reboot
fc-cache -fv # Refresh fonts
sudo reboot # If you don't have admin privileges. Just close and open the terminal
