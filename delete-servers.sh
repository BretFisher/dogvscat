#!/bin/bash

# create managers servers
for server in {1..3}; do
docker-machine rm -y dvc${server} &
done

# create servers





