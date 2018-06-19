#!/bin/bash
set -x

# delete all docker machines starting with dvc
for server in {1..3}; do
docker-machine rm -y dvc${server} &
done

# delete all storage in DO (be sure you are ok deleting ALL storage in an account)
# doctl compute volume ls --format ID --no-header | while read -r id; do doctl compute volume rm -f "$id"; done




