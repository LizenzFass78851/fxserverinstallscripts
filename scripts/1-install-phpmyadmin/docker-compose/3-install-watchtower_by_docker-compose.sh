#!/bin/bash

set -e # Exit the script on error

# script
mkdir -p ~/server/docker/watchtower
cd ~/server/docker/watchtower

wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/docker-templates/watchtower/docker-compose.yml

docker compose up -d
