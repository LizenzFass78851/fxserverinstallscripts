#!/bin/bash

set -e # Exit the script on error

if ! test -x /bin/curl; then
    echo "The package 'curl' is not installed."
    echo "Please install the package 'curl' using your Distro's Package Manager (e.g., Debian and Ubuntu use 'apt')."
    exit 1
fi


# script
echo start Docker install Script from docker.com
curl -sSL https://get.docker.com | bash

echo make a link to "docker-compose" from "docker compose"
echo -e '#!/bin/sh\nexec docker compose "$@"' | tee /usr/local/bin/docker-compose && \
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

echo done
