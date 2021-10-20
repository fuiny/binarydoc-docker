#!/bin/sh
#
# Clean up local docker images
# Note. All local data will be removed and cannot be recovered


sudo docker-compose down --rmi local 
sudo docker image rm fuiny/binarydoc
sudo rm -rf apache2-log/ minio-data/ mysql-data/ web-sitemap/
echo "$0 Finished"

