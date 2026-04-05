#!/bin/bash

set -e # Exit the script on error

USE_OLD_DOCKER_INSTALL_SCRIPT=${USE_OLD_DOCKER_INSTALL_SCRIPT:-0} # 0 = use new script, 1 = use old script

docker-com-script() {
if ! command -v curl &> /dev/null; then
    echo "The package 'curl' is not installed."
    echo "Please install the package 'curl' using your Distro's Package Manager (e.g., Debian and Ubuntu use 'apt')."
    exit 1
fi

# script
echo "start Docker install Script from docker.com"
curl -sSL https://get.docker.com | bash

echo "done"
}

old-docker-script() {
local DEBIAN_FRONTEND=noninteractive

# Remove old versions of Docker
apt-get remove -y docker docker-engine docker.io containerd runc

# Update the package index
apt-get update

# Install required packages
apt-get install -y \
    ca-certificates \
    curl \
    gnupg

# Set up the Docker repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $UBUNTU_CODENAME) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
echo "Updating package index..."
apt-get update -qq

# Install Docker packages
echo "Installing Docker packages..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if docker compose version &> /dev/null; then
    echo "Docker Compose is installed."
else
    echo "Docker Compose is not installed."
    echo "Installing Docker Compose..."
    curl -SL $(curl -L -s https://api.github.com/repos/docker/compose/releases/latest | grep -o -E "https://(.*)docker-compose-linux-$(uname -m)") -o /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi
}

if [ "$USE_OLD_DOCKER_INSTALL_SCRIPT" -eq 1 ]; then
    old-docker-script
else
    docker-com-script
fi
