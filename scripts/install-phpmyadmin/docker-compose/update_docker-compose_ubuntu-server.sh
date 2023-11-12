#!/bin/bash


# script
apt purge docker-compose -y
apt autoremove -y

rm /usr/local/bin/docker-compose
rm /usr/bin/docker-compose

curl -SL $(curl -L -s https://api.github.com/repos/docker/compose/releases/latest | grep -o -E "https://(.*)docker-compose-linux-$(uname -m)") -o /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
