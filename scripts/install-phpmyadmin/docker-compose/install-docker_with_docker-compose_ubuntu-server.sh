#!/bin/bash


# script
curl -sSL https://get.docker.com | bash

echo -e '#!/bin/sh\nexec docker compose "$@"' | tee /usr/local/bin/docker-compose && \
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose
