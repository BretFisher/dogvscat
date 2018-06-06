#!/bin/bash

# create managers servers
for server in {4..20}; do
docker-machine rm -y dvc${server} &
done

# create servers





