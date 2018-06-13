# dogvscat (Work In Progress)

This repo gives a few examples of patterns for how you might build Docker Swarm clusters with all the bells and whistles. 

A Docker Swarm cluster needs more then just your app running, it often needs at least these additional services:

- Layer 7 Reverse Proxy (to host multiple HTTP sites on one port)
- Swarm-aware storage for data persistance
- Centralized logging of your app containers
- Centralized monitoring of nodes and containers
- Cluster management GUI
- Continuous deployment of updated images

This demo is meant for you to `git clone` and run locally to help you learn the tools and methods for building a complete Docker Swarm cluster.

## Getting Started

This repo holds two deployment examples for Docker Swarm

- Docker Swarm CE (Community Edition) open source stack
- Docker Swarm EE (Enterprise Edition) stack

The EE stack requires at least a trial license to deploy.

## Deploying the Swarm CE Example

You can do all this locally on a single node or optionally using Docker Machine to multi-node clusters.

### Step 1: Set needed environment variables

The scripts and compose/stack files use variables to make this demo easier to get started. Set these at your shell before running commands

```
TODO: add envs
```

### Step 2: (single node local Swarm)

Just have Docker installed, either via Docker for Windows/Mac or on Linux. See my [YouTube videos on the proper way to setup your OS for Docker](https://www.youtube.com/watch?v=Fc7Rjll30jY&list=PL6cactdCCnTLqhFgmXAVdwLPCM_SZdGYq) using downloads from [store.docker.com](https://store.docker.com).

Then just create a single-node Swarm in that engine:

`docker swarm init`

### Step 2: (multi-node docker-machine Swarm)

`./create-servers.sh` gives example docker-machine commands for creating 3 nodes in various VM environments including locally with VirtualBox, Hyper-V, and in the cloud using Digital Ocean.

### Step 3: Enable Docker Engine Metrics

### Step 4: Initialize Swarm and Join Nodes

### Step 5: Enable Persistent Storage with REX-Ray

### Step 6: Deploy Reverse Proxy using Traefik

### Step 7: Deploy Ops Tools: ELK, Prometheus, and Portainer

### Step 8: Deploy sample apps and test

## Deploying the Swarm EE Example

TODO