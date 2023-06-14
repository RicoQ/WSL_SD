#!/bin/Bash

# Update & Upgrade
sudo apt-get update --fix-missing && sudo apt-get -y upgrade 

# Clone Stable Diffusion Web UI Repo
sudo apt-get install -y git 
printf "\n #####################\n # Preparing AUTOMATIC1111 # \n #####################\n\n"
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

printf "\n #####################\n #   Getting  Ready   # \n #####################\n\n"
echo "Creating ./Scripts Folder"
mkdir Scripts

echo "Moving all Scripts to the ./Scripts Folder"
mv ./1_* ./Scripts
mv ./2_* ./Scripts
mv ./3_* ./Scripts

echo "Preparing The SD.sh script" 
mv ~/SD.sh ~/stable-diffusion-webui/SD.sh
chmod +x ~/stable-diffusion-webui/SD.sh

echo "Making all the Scripts in ./Scripts Folder Executable"
sudo chmod +x ./Scripts/*.sh

printf "\n #####################\n # Configurating WSL # \n #####################\n\n"
bash ./Scripts/1_*.sh
printf "\n #####################\n # Setting up Conda  # \n #####################\n\n"
bash ./Scripts/2_*.sh

exit