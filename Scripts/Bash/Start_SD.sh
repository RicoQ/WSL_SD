#!/bin/bash

run() {
   #cd ~/stable-diffusion-webui/
   #./SD.sh $1
   bash ~/stable-diffusion-webui/SD.sh $1
}

# Function to handle command line arguments and initialize variables
init_var() {
    if [[ $# == 0 ]]; then
      run
    else
      if [[ $# -gt 1 ]]; then
	echo " "
	echo "## Too many arguments"
	echo " "
	help_msg
	exit 1
      fi
      while [[ $# -gt 0 && $# -lt 2 ]]; do
        case "$1" in
           "--update" | "-U")
              run "-U"
              ;;
           "--lama" | "-L")
              run "-L"
              ;;
           "--reinstall" | "-R")
              run "-R"
              ;;
           "--help" | "-H" | "-h")
              help_msg
              exit
              ;;
           *)
              echo " "
              echo "## Invalid argument: $1"
	      echo " "
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
        echo "  --reinstall, -R       execute '-U' and Reinstall Torch & Xformer after starting SD (not used with -L)"
	     echo "                        using -U with -R is redondent and unessesary"
        echo "  --help, -H, -h        Shows this help text"
        echo ""
}

# Initialize variables and handle command line arguments
init_var "$@"
