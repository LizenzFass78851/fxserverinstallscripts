#!/bin/bash

# set this
# see under


# script
cd ~
mkdir server
cd server


mkdir docker
cd docker

mkdir phpmyadmin
cd phpmyadmin

wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/multiuser/files/phpmyadmin/docker-compose.yml


### set this "yourpassword" to your password
sed -i 's/PASSWORD=bitnami/PASSWORD=yourpassword/g' ./docker-compose.yml


docker-compose up -d

echo wait 10 seconds
sleep 10

chmod -R 777 ./db
docker-compose down && docker-compose up -d
