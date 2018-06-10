#!/bin/bash
set -x

# create a swarm as all managers
docker-machine ssh dvc1 docker swarm init --listen-addr=eth1 --data-path-addr=eth1 --advertise-addr=eth1

docker-machine ssh dvc1 docker swarm join-token manager

# copy this command and add run it on other nodes
# docker-machine ssh dvc2 <paste command>
