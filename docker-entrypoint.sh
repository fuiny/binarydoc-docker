#!/bin/bash
set -e

# Refresh DB Schema

# Init MySQL login path


echo "Starting Apache2 HTTPD in foreground."
source /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND
