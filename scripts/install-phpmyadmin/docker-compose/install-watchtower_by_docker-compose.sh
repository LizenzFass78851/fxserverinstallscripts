#!/bin/bash

# script
cd ~
mkdir server
cd server


mkdir docker
cd docker

mkdir watchtower
cd watchtower

wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/multiuser/files/watchtower/docker-compose.yml



docker-compose up -d
