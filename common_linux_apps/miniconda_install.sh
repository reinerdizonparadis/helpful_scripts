#!/bin/bash

sudo mkdir -p /opt/miniconda3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda3/miniconda.sh
sudo bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3
sudo rm -rf /opt/miniconda3/miniconda.sh
/opt/miniconda3/bin/conda init bash
/opt/miniconda3/bin/conda init zsh
