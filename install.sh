#!/usr/bin/env bash

cd ~/
git clone https://github.com/oleh-polishchuk/bash-service.git
cd ./bash-service/
echo "export PATH=$(pwd)/bin:$PATH" >> ~/.bash_profile

source ~/.bash_profile
