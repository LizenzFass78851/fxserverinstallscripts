#!/bin/bash

set -e # Exit the script on error

if ! command -v curl &> /dev/null; then
    echo "The package 'curl' is not installed."
    echo "Please install the package 'curl' using your Distro's Package Manager (e.g., Debian and Ubuntu use 'apt')."
    exit 1
fi

# script
echo "start Docker install Script from docker.com"
curl -sSL https://get.docker.com | bash

echo "done"
