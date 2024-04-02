#!/bin/bash

# script
cd ~

mkdir -p server/docker/watchtower
cd server/docker/watchtower

wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/multiuser/files/watchtower/docker-compose.yml



docker-compose up -d
