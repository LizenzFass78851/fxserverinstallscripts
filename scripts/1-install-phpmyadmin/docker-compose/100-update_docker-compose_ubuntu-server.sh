#!/bin/bash

set -e # Exit the script on error

# script
apt purge -y docker-compose && \
  apt autoremove -y

rm -f /usr/local/bin/docker-compose && \
  rm -f /usr/bin/docker-compose

echo -e '#!/bin/sh\nexec docker compose "$@"' | tee /usr/local/bin/docker-compose > /dev/null && \
  ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose
