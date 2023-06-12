#!/bin/bash
# Setting sudo privileges: (I like to be the all-mighty on my system! How about you?)
echo "$USER ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Add the following to ~/.bashrc
echo 'source ~/.aliases' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Add the following to ~/.aliases^M$
cat > ~/.aliases << END
## Custom Aliases

# Aptitude
alias Apt='sudo aptitude'
alias Upgrade='Apt upgrade -y'
alias Update='Apt update'
alias UPGRADE='Update && Upgrade'
alias Install='Apt install -y'
alias Search='Apt search'
alias Purge='Apt purge --auto-remove'
alias Remove='Apt remove'

# System
alias Sys='sudo systemctl'
alias Enable='Sys enable'
alias Start='Sys start'
alias Stop='Sys stop'
alias Reload='Sys daemon-reload'
alias Restart='Sys restart'
alias Status='Sys status'
alias Service='sudo service'
alias ifconfig='sudo ifconfig'
alias iptables='sudo iptables'
alias Source='sudo source'
alias Shutdown='sudo shutdown -fh now'
alias Reboot='sudo reboot -f'
alias Python='sudo python'

# Common
alias cd..='cd ..'
alias Dir='ls -1aF'
alias LS='ls -lah'
alias Less='sudo less'
alias Find='sudo find / -name'
alias Grep='sudo grep'
alias Cat='sudo cat'
alias Tail='sudo tail -f'
alias RM='sudo rm'
alias CP='sudo cp'
alias MV='sudo mv'

# chmod & chown
alias chmod='sudo chmod'
alias Chmod='chmod'
alias CMX='chmod +x'
alias chown='sudo chown'
alias Chown='chown'
alias COU='chown $USER:$USER'
alias COR='chown root:root'

# Utilities
alias Nano='sudo nano'
alias Git='sudo git'
alias python='python3'
alias Python='sudo python'
END

# Install necessary utilities
#sudo apt-get install -y aptitude
sudo apt-get install -y ifupdown ufw htop net-tools ncdu wget ltrace python2.7 curl nano pkg-config inxi dkms build-essential git python3 python3-venv pkg-config screen python3-pip zsh

# Add the following to ~/.bashrc
source ~/.bashrc

# Install "Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install PowerLevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Configure ~/.zshrc
sed -i 's/^export PATH=$HOME\/bin:\/usr\/local\/bin:$PATH$/&\nsource ~/.aliases\nexport EDITOR=nano\nexport PATH=$HOME\/.local\/bin:$PATH\n/' ~/.zshrc

# Comment the following line (ZSH_THEME)
sed 's/^ZSH_THEME="robbyrussell"/#ZSH_THEME="robbyrussell"/g' ~/.zshrc
# Then add the ZSH_THEME we want right after it
sed '/^#ZSH_THEME="robbyrussell"/a ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

# Add The Folowinf 3 lines at the End of ~/.zshrc
printf "
export PATH=$HOME/bin:/usr/local/bin:$PATH
source ~/.aliases
export EDITOR=nano
export PATH=$HOME/.local/bin:$PATH
" >> ~/.zshrc

# Run the PowerLevel10k theme
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# Restart WSL
#echo "Restarting WSL..."
#wsl.exe --shutdown