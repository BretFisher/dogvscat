#!/bin/sh

# this short script will post some HTTP data to the Voting app to generate votes
# this makes for a better demo and if you can see the results then you know the solution works

# create POST data files with ab friendly formats
python make-data.py

# create 3000 votes
ab -n 1000 -c 50 -p posta -T "application/x-www-form-urlencoded" http://vote.dogvs.cat/
ab -n 1000 -c 50 -p postb -T "application/x-www-form-urlencoded" http://vote.dogvs.cat/
ab -n 1000 -c 50 -p posta -T "application/x-www-form-urlencoded" http://vote.dogvs.cat/
