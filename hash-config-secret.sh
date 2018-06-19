#!/bin/sh
set -x

# this is part of a solution to Swarm Stack Configs that change
# TODO: explain how this works in readme

export LOGSTASH_CONF=$(shasum logstash.conf -a 512 | cut -c1-16)

