#!/bin/sh
#

echo "Re-build the docker image"

./cleanup.sh
./build.sh

# Start up
sudo docker-compose up -d
