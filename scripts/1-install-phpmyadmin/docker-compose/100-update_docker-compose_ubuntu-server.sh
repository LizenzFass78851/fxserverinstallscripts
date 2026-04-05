#!/bin/bash

set -e # Exit the script on error

if docker compose version &> /dev/null; then
    echo "Docker Compose always is installed."
else
    if [ -f /usr/local/bin/docker-compose ] && docker-compose version &> /dev/null; then
        echo "Updating Docker Compose..."
        rm -f /usr/local/bin/docker-compose && rm -f /usr/bin/docker-compose
        curl -SL $(curl -L -s https://api.github.com/repos/docker/compose/releases/latest | grep -o -E "https://(.*)docker-compose-linux-$(uname -m)") -o /usr/local/bin/docker-compose
        ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    else
        echo "Docker Compose is not installed. Exiting..."
        exit 1
    fi
fi
