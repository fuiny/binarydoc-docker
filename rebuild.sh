#!/bin/sh
#
# Script to re-build the docker image in local
#


# Clean up
sudo docker-compose down --rmi all 
sudo rm -rf mysql-data/ apache2-log/

# Build
./build.sh

# Start up
sudo docker-compose up -d
