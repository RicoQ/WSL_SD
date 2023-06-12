#!/bin/bash

# Function Update and Run Lama_cleaner
run_lama() {
	if [ ! -d "./lama-cleaner" ]; then
		msg "Did not Find lama-cleaner"
		msg "Installing lama now" 
		git pull https://github.com/Sanster/lama-cleaner.git
    fi
    msg "Lama-Cleaner"
	echo "Updating Lama-cleaner (Git Pull)"
	lama_folder="./lama-cleaner"
	git_pull "$lama_folder"

	echo "Updating Requirements for Lama-Cleaner"
	lama_file="./lama-cleaner/requirements.txt"
	pip install -r "$lama_file"

    echo ""
	echo "########## Starting Lama-Cleaner ##########"
	echo ""
	lama-cleaner --model=lama --device=cpu --port=8080
}

# Function to Update & Activate the Conda Environment
conda_env() {
    msg "Conda Environment"
	echo "Activating Conda environment: $1"
	conda_env_name="$1"

	echo "Initializing Conda in the current shell session"
	eval "$(/home/admin/anaconda3/bin/conda shell.bash hook)"

	echo "Updating Base Conda"
	conda update -y --force-reinstall conda
	conda update -y -n base -c defaults conda

	echo "Updating the Conda environment"
	conda env update --file ./environment-wsl2.yaml

	echo "Activating the Conda environment"
	conda activate "$conda_env_name"

	echo "Installing chardet module"
	pip install chardet

    msg "Stable Diffusion"
	echo "Updating all SD extensions"
	ext_folder="./extensions"
	git_pull "$ext_folder"

	echo "Updating SD"
	file="./requirements.txt"
	pip install -r "$file"
	git pull
    
    if [[ $1 == "R" ]]; then
       reinstall
    else   
       run_sd
    fi
    exit
}

# Function to recursively perform git pull
git_pull() {
	for item in "$1"/*; do
		if [[ -d "$item" && -d "$item/.git" ]]; then
			echo "Updating $item"
			pushd "$item" > /dev/null
			git pull
			popd > /dev/null
		elif [[ -d "$item" ]]; then
			git_pull "$item"
		fi
	done
}

# Function to print a message
msg() {
	echo ""
	echo "#########################################"
	echo "#                                       #"
	echo "# Updating $1		#"
	echo "#                                       #"
	echo "#########################################"
	echo ""
}

# Function to run Stable Diffusion
run_sd() {

	echo ""
	echo "########## Starting Stable Diffusion ##########"
	echo ""
	python launch.py --api --lowvram --xformers --disable-nan-check --disable-safe-unpickle --no-half --no-half-vae --update-check #--skip-torch-cuda-test
}

# Run Stable Diffusion without updates
main() {
    env_name="automatic"
	conda_env_name="$env_name"

	echo "Initializing Conda in the current shell session"
	eval "$(/home/admin/anaconda3/bin/conda shell.bash hook)"
	
	echo "Activating the Conda environment"
	conda activate "$conda_env_name"

    echo ""
	echo "########## Starting Stable Diffusion ##########"
	echo ""
	python launch.py --api --lowvram --xformers --disable-nan-check --disable-safe-unpickle --no-half --no-half-vae --update-check --skip-torch-cuda-test
    exit
}

# Function to handle command line arguments and initialize variables
init_var() {
    if [[ $# == 0 ]]; then
      main
    else  
	  while [[ $# -gt 0 ]]; do
		case "$1" in
			"--update" | "-U")
				conda_env
				;;
			"--lama" | "-L")
				run_lama
				;;
			"--reinstall" | "-R")
				reinstall="R"
                conda_env "$reinstall"
				;;
			"--help" | "-H" | "-h")
				help_msg
				exit
				;;
			 *)
				echo ""
				echo "Invalid argument: $1"
				help_msg
				exit 1
				;;
		esac
		shift
	  done
    fi
}

# Function to display help message
help_msg() {
	echo ""
	echo "Usage: ./SD.sh [options]"
	echo ""
	echo "Options:"
    echo "  no option             Simply run Stable Diffusion"
	echo "  --update, -U          Updates everything (i.e., SD, all extensions, and the Conda Environment)"
	echo "  --lama, -L            Updates only the Lama Cleaner app and starts it (not used with -R, -U)"
	echo "  --reinstall, -R       Reinstall Torch & Xformer"
    echo "  --help, -H, -h        Shows this help text"
	echo ""
}

# Function to reinstall Torch & Xformer
reinstall() {
	msg "Reinstalling Torch & Xformer / starting SD"
	python launch.py --reinstall-xformers --reinstall-torch --lowvram --xformers --disable-nan-check --disable-safe-unpickle --no-half --no-half-vae --update-check #--skip-torch-cuda-test
	exit
}

# Initialize variables and handle command line arguments
init_var "$@"