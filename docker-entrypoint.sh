#!/bin/bash
set -e

# Init MySQL login path
#  - https://stackoverflow.com/questions/42232310/pass-password-to-mysql-config-editor-using-variable-in-shell
host=binarydoc-db
user=root
pass=123456

rm -f ~/.mylogin.cnf

unbuffer expect -c "
spawn mysql_config_editor set --login-path=binarydocjvm    --host=$host --user=$user --password
expect -nocase \"Enter password:\" {send \"$pass\r\"; interact}
"

unbuffer expect -c "
spawn mysql_config_editor set --login-path=binarydocjvmadm --host=$host --user=$user --password
expect -nocase \"Enter password:\" {send \"$pass\r\"; interact}
"

# Prepare DB
echo "Waiting for DB is Ready ..."
sleep 16

echo "Create DB Users if not exist"
mysql --login-path=binarydocjvmadm  <  /opt/fuiny/binarydoc-db/create-users.sql

# TODO "if not exists"
echo "Create DB Schema for Admin if not exists"
mysql --login-path=binarydocjvmadm  <  /opt/fuiny/binarydoc-db/binarydocjvmadm-create.sql

# Update configuration
sed -i "s/127.0.0.1/binarydoc-db/g" /opt/fuiny/binarydoc-parser/etc/binarydoc-jvm.properties
sed -i "s/localhost/binarydoc-db/g" /opt/fuiny/binarydoc-parser/etc/binarydoc-jvm.properties
sed -i "s/127.0.0.1/binarydoc-db/g" /var/www/php-library/config/dbconfig.php

echo "Starting Apache2 HTTPD in foreground."
source /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND
