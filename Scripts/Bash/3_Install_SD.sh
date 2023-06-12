#!/bin/bash

# Clone Stable Diffusion Web UI Repo
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

function Install_SD() {
    # Create conda environment (Run this command in the "stable-diffusion-webui" folder)
    cd stable-diffusion-webui/
    conda env create -f environment-wsl2.yaml

    # Activate conda environment
    conda activate automatic

    # Create new repositories folder under stable-diffusion-webui
    mkdir repositories

    # Clone more repositories
    git clone https://github.com/CompVis/stable-diffusion.git repositories/stable-diffusion
    git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers
    git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer
    git clone https://github.com/salesforce/BLIP.git repositories/BLIP

    # Install pip packages
    pip install transformers diffusers invisible-watermark --prefer-binary
    pip install git+https://github.com/crowsonkb/k-diffusion.git --prefer-binary
    pip install git+https://github.com/TencentARC/GFPGAN.git --prefer-binary
    pip install -r repositories/CodeFormer/requirements.txt --prefer-binary
    pip install -r requirements.txt --prefer-binary
    pip install -U numpy --prefer-binary
    pip install opencv-python-headless

    # Install CUDA
    conda install cuda -c nvidia

    # Install the requirements
    pip install -r requirements.txt
    exit
}

Install_SD

# Download/copy model file to "stable-diffusion-webui/models/Stable-diffusion" folder
wget -O ./stable-diffusion-webui/models/Stable-diffusion https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors
wget -O ./stable-diffusion-webui/models/Stable-diffusion https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors

# Preparing The SD.sh script 
mv ~/SD.sh ~/stable-diffusion-webui
chmod +x ~/SD.sh

# Add WSL to path
echo 'export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH' >> ~/.zshrc

# Restart Terminal
source ~/.zshrc
exit