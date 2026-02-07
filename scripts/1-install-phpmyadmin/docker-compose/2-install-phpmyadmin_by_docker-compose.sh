#!/bin/bash

set -e # Exit the script on error

function pw() {
    < /dev/urandom tr -dc A-Za-z0-9 | head -c $1; echo
}

RANDOMPASSWD=$(pw 16)

# script
mkdir -p ~/server/docker/phpmyadmin
cd ~/server/docker/phpmyadmin 

wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/docker-templates/phpmyadmin/docker-compose.yml

echo "    environment:" >> docker-compose.yml
echo "      - MARIADB_ROOT_PASSWORD=$RANDOMPASSWD" >> docker-compose.yml

docker compose up -d

echo "/////////////////////////////////////////////////////////////"
echo "PHPMYADMIN and SQL Root Password:"
echo "$RANDOMPASSWD"
echo "/////////////////////////////////////////////////////////////"

echo "Please make sure you write down the password!"
echo "Only with the password can you access the phpmyadmin UI."

