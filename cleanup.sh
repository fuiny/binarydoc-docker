#!/bin/sh
#
# Clean up local docker images
# Note. All local data will be removed and cannot be recovered


sudo docker-compose down --rmi all 
sudo rm -rf mysql-data/ apache2-log/ web-sitemap/
echo "$0 Finished"
