#!/bin/sh
#

echo "Delete current docker images (if exists) and re-create new one from server"

./cleanup.sh

# Start up
sudo docker-compose up -d
