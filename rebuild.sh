#!/bin/sh
#
# Script to re-build the docker image in local
#


# Clean up
./cleanup.sh

# Build
./build.sh

# Start up
sudo docker-compose up -d
