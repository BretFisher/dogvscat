#!/bin/sh
export LOGSTASH_CONF=$(shasum logstash.conf -a 512 | cut -c1-16)

