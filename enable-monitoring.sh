#!/bin/bash
set -x

# enable monitoring
for server in {1..3}; do
  docker-machine scp daemon.json dvc${server}:/etc/docker/ && 
  docker-machine ssh dvc${server} systemctl restart docker &
done
