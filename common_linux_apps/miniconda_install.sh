#!/bin/bash

MINICONDA_PATH=/opt/miniconda3

sudo mkdir -p ${MINICONDA_PATH}
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${MINICONDA_PATH}/miniconda.sh
sudo bash ${MINICONDA_PATH}/miniconda.sh -b -u -p ${MINICONDA_PATH}
sudo rm -rf ${MINICONDA_PATH}/miniconda.sh

# ${MINICONDA_PATH}/bin/conda init bash

