#!/bin/bash
# set -x

# create managers servers in digital ocean with pre-set environment vars
# https://docs.docker.com/machine/drivers/digital-ocean/

# DO_TOKEN get the token from digitalocean.com (read/write)
# DO_SIZE pick your droplet size from "doctl compute size list"
# SSH_FINGERPRINT in the format of "8d:30:8a..." with a comand like "ssh-keygen -E md5 -lf  ~/.ssh/id_rsa.pub"

for server in {1..3}; do
docker-machine create \
  --driver=digitalocean \
  --digitalocean-access-token="${DO_TOKEN}" \
  --digitalocean-size="${DO_SIZE}" \
  --digitalocean-ssh-key-fingerprint="${SSH_FINGERPRINT}" \
  --digitalocean-tags=dogvscat \
  --digitalocean-private-networking=true \
  dvc${server} &
done


# if you wanted to create these locally in virtualbox, you might do this
# remember to check if you have enough RAM
# https://docs.docker.com/machine/drivers/virtualbox/

#for server in {1..3}; do
#docker-machine create \
#  --driver=virtualbox \
#  --virtualbox-memory=2048 \
#  dvc${server} &
#done

# if you wanted to create these locally in hyper-v (windows 10), you might do this from git bash
# remember to check if you have enough RAM and if virtual switch is created
# https://docs.docker.com/machine/drivers/hyper-v/

#for server in {1..3}; do
#docker-machine create \
#  --driver=hyperv \
#  --hyperv-memory=2048 \
#  --hyperv-virtual-switch="Primary Virtual Swtich" \
#  dvc${server} &
#done
