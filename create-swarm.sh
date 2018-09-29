#!/bin/bash
set -x

# since we created droplets with a private NIC on eth1, lets use that for swarm comms
LEADER_IP=$(docker-machine ssh dvc1 ifconfig eth1 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')

# create a swarm as all managers
docker-machine ssh dvc1 docker swarm init --advertise-addr "$LEADER_IP"

# note that if you use eth1 above (private network in digitalocean) it makes the below
# a bit tricky, because docker-machine lists the public IP's but we need the 
# private IP of manager for join commands, so we can't simply envvar the token
# like lots of scripts do... we'd need to fist get private IP of first node

# TODO: provide flexable numbers at cli for x managers and x workers
JOIN_TOKEN=$(docker-machine ssh dvc1 docker swarm join-token -q manager)

for i in 2 3; do
  docker-machine ssh dvc$i docker swarm join --token "$JOIN_TOKEN" "$LEADER_IP":2377
done

docker-machine env dvc1

