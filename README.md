# Dog vs. Cat: Docker Swarm Stacks on Stacks on Stacks

Meanwhile, follow along this presentation I made during DockerCon 2018
https://youtu.be/V9fxU5zJKb4

[![DockerCon EU Swarm Stack](https://img.youtube.com/vi/V9fxU5zJKb4/0.jpg)](https://youtu.be/V9fxU5zJKb4)

This repo gives a few examples of patterns for how you might build Docker Swarm clusters with all the bells and whistles you would need in a real world setup. Note [I have a course on Swarm for $10 on Udemy](http://swarmmastery.com).

A Docker Swarm cluster needs more then just your app running, it often needs at least these additional services:

- Layer 7 Reverse Proxy (to host multiple HTTP sites on one port)
- Swarm-aware storage for data persistence
- Centralized logging of your app containers
- Centralized monitoring of nodes and containers
- Cluster management GUI
- Continuous deployment of updated images

This demo is meant for you to `git clone` and run locally to help you learn the tools and methods for building a complete Docker Swarm cluster.

# Major To-Do's left (see feature requests in Issues)

- [ ] Show how docker-app could be used for better Continuous Deployment
- [ ] Show how to deploy servers with simple Terraform and/or Ansible examples
- [ ] Show how 18.09 SSH makes remote admin so easy
- [ ] Pull out everything that needs envvars
- [ ] Use Docker Swarm Secrets for privates
- [ ] Fix Docker EE Ansible permissions on ELB's and Security groups for port 8080 (app ELB)
- [x] Better README step-by-step
- [x] Walkthough videos

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

`./enable-monitoring.sh` simply overwrite `/etc/docker/daemon.json` (we assume it doesn't exist) with two options to enabling the metrics endpoint, which will help Prometheus with more metrics later.
```json
{
  "metrics-addr" : "0.0.0.0:9323",
  "experimental" : true
}
```

### Step 4: Initialize Swarm and Join Nodes

`./create-swarm.sh` gives example docker-machine ssh commands for `docker swarm init` and `join` operations.

After this finishes, if you're using my docker-machine example you can connect to Docker TLS endpoint on node1 via:

`docker-machine env dvc1` and then copy/paste the last line of output for your OS.

### Step 5: Enable Persistent Storage with REX-Ray

From this point on, everything is in stack files! No custom node config's needed. 🎉

`docker stack deploy -c stack-rexray.yml rexray`

This sets up a global service to run a docker command against the host docker socket via bind-mount to install the storage driver for your cloud. Change the driver name to your cloud or docker volume storage plug-in vendor. This method of wrapping swarm-exec in a global mode service also means any new nodes to join the Swarm later will get the driver installed.

**The above shows off how you can use swarm-exec utility to run a command (even a docker host command) on a set of nodes**

### Step 6: Deploy Reverse Proxy using Traefik

Simple Proxy: `docker stack deploy -c stack-proxy.yml proxy`

This sets up a simple single-container proxy using Swarms ingress routing mesh to reverse proxy ports 80 and 443. It's good for demos and personal setups but you'll likely want something more as you grow.

**The above shows off how you can use a reverse proxy to control traffic to many web URL's via their DNS name, and also includes Let's Encrypt dynamic config and cert requests**

Advanced Proxy: `docker stack deploy -c stack-proxy-global.yml proxy`

This example builds on the simple proxy and adds a global mode Traefik service for HA proxy, and also runs the 80/443 listeners on the host NIC for improved performance and gathering of real client IP's (it then uses overlay networks to talk to app services). For HA Traefik it needs a key/value store so this example uses a single Consul container with RexRay storage. Lastly, it enables a socat container to allow Traefik to run on worker nodes while it uses TCP to talk to the Swarm management API via socat redirect.

**The above shows off how to use host NIC directly in a service to avoid routing mesh, how to encrypt a network with IPSec, and how to use socat to redirect a docker socket to the network so you can void putting management containers on managers.**

### Step 7: Deploy Ops Tools: ELK, Prometheus, and Portainer

`docker stack deploy -c docker-elk/docker-stack.yml -c elk.override.yml elk`
`docker stack deploy -c swarmprom/docker-compose.yml prom`
`docker stack deploy -c stack-portainer.yml portainer`

### Step 8: Deploy management tasks like prune

`docker stack deploy -c stack-prune.yml prune`

### Step 9: Deploy sample apps and test

`docker stack deploy -c stack-menu.yml menu`
`docker stack deploy -c stack-voting.yml vote`
`docker stack deploy -c stack-ghost.yml ghost`

## Deploying the Swarm EE Example

## Other Notes

### Using Docker Machine? Really???
- Don't throw out the good in search of the perfect
- DM works fine solo admins with 3-10 cloud servers
- Be sure to backup certs from .docker/machine/machines
- If you're a team of 2-3 and still want to try sticking with DM, maybe try:
  - https://github.com/bhurlow/machine-share
  - https://github.com/efrecon/machinery

### Swarm Visualizer
- You can optionally deploy `stack-visualizer.yml` early on to see how your stacks and services fill out your swarm on port 4040.

`docker stack deploy -c stack-visualizer.yml viz`
