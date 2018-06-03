#!/bin/bash

# create managers servers
for server in 1 2 3 4 5; do
docker-machine create \
  --driver=digitalocean \
  --digitalocean-access-token="${DO_TOKEN}" \
  --digitalocean-size="${DO_SIZE}" \
  --digitalocean-private-networking=true \
  --digitalocean-ssh-key-fingerprint="${SSH_FINGERPRINT}" \
  --digitalocean-tags=dogvscat \
  dvc${server} &
done

# create servers





