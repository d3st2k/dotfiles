# Configs

Hi to everyone,
This is my personal 
Just run this code section in your terminal

```
cd # Go to $HOME dir

# Clone the repo (You need GIT set up ofc!!)
git clone https://github.com/d3st2k/configs.git
# git clone git@github.com:d3st2k/configs.git # If you use SSH

# Create symlinks to point to repo
ln -s ~/configs/nvim ~/.config/nvim
ln -s ~/configs/fonts ~/.fonts

# Reboot
fc-cache -fv # Refresh fonts
sudo reboot # If you don't have admin privileges. Just close and open the terminal

```
