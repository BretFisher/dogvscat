#!/bin/bash
set -x

# create managers servers in digital ocean with pre-set environment vars
# https://docs.docker.com/machine/drivers/digital-ocean/
for server in {1..3}; do
docker-machine create \
  --driver=digitalocean \
  --digitalocean-access-token="${DO_TOKEN}" \
  --digitalocean-size="${DO_SIZE}" \
  --digitalocean-private-networking=true \
  --digitalocean-ssh-key-fingerprint="${SSH_FINGERPRINT}" \
  --digitalocean-tags=dogvscat \
  dvc${server} &
done

# if you wanted to create these locally in virtualbox, you might do this
# remember to check if you have enough RAM
# https://docs.docker.com/machine/drivers/virtualbox/

#for server in {1..3}; do
#docker-machine create \
#  --driver=virtualbox \
#  --virtualbox-memory=2 \
#  dvc${server} &
#done

# if you wanted to create these locally in hyper-v (windows 10), you might do this from git bash
# remember to check if you have enough RAM and if virtual switch is created
# https://docs.docker.com/machine/drivers/hyper-v/

#for server in {1..3}; do
#docker-machine create \
#  --driver=hyperv \
#  --hyperv-memory=2 \
#  --hyperv-virtual-switch="Primary Virtual Swtich" \
#  dvc${server} &
#done
