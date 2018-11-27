# Dog vs. Cat (Work In Progress. Not fully documented)

Meanwhile, follow along this presentation I made during DockerCon 2018
https://dockercon2018.hubs.vidyard.com/watch/k3Cv676wmxAwYDxbvcgcgC

[![screen shot 2018-08-16 at 2 14 20 pm](https://user-images.githubusercontent.com/6694151/44226710-bcb86900-a15e-11e8-87cf-ad930cfc8241.jpg)](https://dockercon2018.hubs.vidyard.com/watch/k3Cv676wmxAwYDxbvcgcgC)

This repo gives a few examples of patterns for how you might build Docker Swarm clusters with all the bells and whistles. 

A Docker Swarm cluster needs more then just your app running, it often needs at least these additional services:

- Layer 7 Reverse Proxy (to host multiple HTTP sites on one port)
- Swarm-aware storage for data persistance
- Centralized logging of your app containers
- Centralized monitoring of nodes and containers
- Cluster management GUI
- Continuous deployment of updated images

This demo is meant for you to `git clone` and run locally to help you learn the tools and methods for building a complete Docker Swarm cluster.

# Major To-Do's left

- [ ] Pull out everything that needs envvars
- [ ] Use Docker Swarm Secrets for privates
- [ ] Fix Docker EE Ansible permissions on ELB's and Security groups for port 8080 (app ELB)
- [ ] Better README step-by-step
- [ ] Walkthough videos

## Getting Started

This repo holds two deployment examples for Docker Swarm

- Docker Swarm CE (Community Edition) open source stack
- Docker Swarm EE (Enterprise Edition) stack

The EE stack requires at least a trial license to deploy.

## Deploying the Swarm CE Example

You can do all this locally on a single node or optionally using Docker Machine to multi-node clusters.

### Step 1: Set needed environment variables

The scripts and compose/stack files use variables to make this demo easier to get started. Set these at your shell before running commands

```shell
# for Digital Ocean docker-machine driver
SSH_FINGERPRINT #fingerprint used to match your SSH key to Digital Ocean's
DO_SIZE #instance size for Digital Ocean to use for docker-machine
DO_TOKEN #Digital Ocean API token for creating/deleting droplets

# for Digital Ocean block storage
REXRAY_DO_TOKEN #Digital Ocean API token so RexRay can create storage volumes, can be same as DO_TOKEN

```

### Step 2: (single node local Swarm)

Just have Docker installed, either via Docker for Windows/Mac or on Linux. See my [YouTube videos on the proper way to setup your OS for Docker](https://www.youtube.com/watch?v=Fc7Rjll30jY&list=PL6cactdCCnTLqhFgmXAVdwLPCM_SZdGYq) using downloads from [store.docker.com](https://store.docker.com).

Then just create a single-node Swarm in that engine:

`docker swarm init`

### Step 2: (multi-node docker-machine Swarm)

`./create-servers.sh` gives example docker-machine commands for creating 3 nodes in various VM environments including locally with VirtualBox, Hyper-V, and in the cloud using Digital Ocean.

### Step 3: Enable Docker Engine Metrics

`./enable-monitoring.sh` simply overwrite `/etc/docker/daemon.json` (we assume it doesn't exist) with two options to enabling the metrics endpoint, which will help Prometheus with more metrics.
```json
{
  "metrics-addr" : "0.0.0.0:9323",
  "experimental" : true
}
```

### Step 4: Initialize Swarm and Join Nodes

### Step 5: Enable Persistent Storage with REX-Ray

### Step 6: Deploy Reverse Proxy using Traefik

### Step 7: Deploy Ops Tools: ELK, Prometheus, and Portainer

### Step 8: Deploy sample apps and test

## Deploying the Swarm EE Example

## Other Notes

### Using Docker Machine? Really???
- Don't throw out the good in search of the perfect
- DM works fine solo admins with 3-20 cloud servers
- Be sure to backup certs from .docker/machine/machines
- If you're a team of 2-3 and still want to try sticking with DM, maybe try:
  - https://github.com/bhurlow/machine-share
  - https://github.com/efrecon/machinery

### Swarm Visualizer
- You can optionally deploy `stack-visualizer.yml` early on to see how your stacks and services fill out your swarm on port 4040.

`docker stack deploy -c stack-visualizer.yml viz`
