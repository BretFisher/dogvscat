#!/bin/bash
# use swarm-exec to install plugin on all nodes
# https://github.com/mavenugo/swarm-exec
docker service create --mode global --name swarm-exec-rexray --restart-condition none \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  mavenugo/swarm-exec:17.03.0-ce \
  docker plugin install --grant-all-permissions rexray/dobs \
  DOBS_REGION=nyc3 \
  DOBS_TOKEN="${REXRAY_DO_TOKEN}" \
  DOBS_CONVERTUNDERSCORES=true
