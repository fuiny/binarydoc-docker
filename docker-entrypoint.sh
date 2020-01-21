#!/bin/bash
set -e

source /etc/apache2/envvars

echo "Starting Apache2 HTTPD in foreground."
exec /usr/sbin/apache2 -D FOREGROUND
