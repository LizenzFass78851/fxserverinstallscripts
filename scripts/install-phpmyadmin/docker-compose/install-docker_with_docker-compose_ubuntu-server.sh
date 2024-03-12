#!/bin/bash


# script
curl -sSL https://get.docker.com | bash

echo -e '#!/bin/sh\nexec docker compose "$@"' | tee /usr/bin/docker-compose && \
  chmod +x /usr/bin/docker-compose
