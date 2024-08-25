#!/bin/bash


# script
apt purge docker-compose -y && \
  apt autoremove -y

rm /usr/local/bin/docker-compose && \
  rm /usr/bin/docker-compose

echo -e '#!/bin/sh\nexec docker compose "$@"' | tee /usr/local/bin/docker-compose && \
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose
