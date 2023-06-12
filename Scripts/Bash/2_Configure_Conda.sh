#!/bin/bash

function conda() {
   # Install required packages
   sudo apt-get install -y python3 wget nano git python3-pip

   # Download Anaconda
   wget -O /tmp/Anaconda3-2023.03-Linux-x86_64.sh https://repo.continuum.io/archive/Anaconda3-2023.03-Linux-x86_64.sh

   # Install Anaconda
   bash /tmp/Anaconda3-2023.03-Linux-x86_64.sh
}

conda
# Exit Terminal
exit