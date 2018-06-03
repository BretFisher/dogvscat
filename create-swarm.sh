#!/sh/bash
docker-machine ssh dvc1 docker swarm init --listen-addr=eth1 --data-path-addr=eth1 --advertise-addr=eth1

