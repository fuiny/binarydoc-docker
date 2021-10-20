#!/bin/sh
#
# Script to generate the docker image in local
#

sudo docker build -t fuiny/binarydoc .

# Show current Docker images and containers
sudo docker images
sudo docker ps -a

