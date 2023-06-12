#!/bin/Bash

echo "Creating ./Scripts Folder"
mkdir Scripts

echo "Moving all Scripts to the ./Scripts Folder"
mv ./1_* ./Scripts
mv ./2_* ./Scripts
mv ./3_* ./Scripts

echo "Making all the Scripts in ./Scripts Folder Executable"
sudo chmod +x ./Scripts/*.sh

printf "\n #####################\n # Configurating WSL # \n #####################\n"
bash ./Scripts/1_*.sh
printf "\n #####################\n # Setting up Conda  # \n #####################\n"
bash ./Scripts/2_*.sh
printf "\n #####################\n #   Installing SD   # \n #####################\n"
bash ./Scripts/3_*.sh

printf "\n #####################\n #    Starting SD    # \n #####################\n"
bash ./Start_SD.sh -U
