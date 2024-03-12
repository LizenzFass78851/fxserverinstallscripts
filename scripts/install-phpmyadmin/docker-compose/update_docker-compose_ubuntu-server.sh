#!/bin/bash


# script
apt purge docker-compose -y
apt autoremove -y

rm /usr/local/bin/docker-compose
rm /usr/bin/docker-compose

echo -e '#!/bin/sh\nexec docker compose "$@"' | tee /usr/bin/docker-compose && \
  chmod +x /usr/bin/docker-compose
