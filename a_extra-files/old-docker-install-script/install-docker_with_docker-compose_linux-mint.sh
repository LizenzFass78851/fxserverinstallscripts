#!/bin/bash

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
apt-get update

# Install Docker packages
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

