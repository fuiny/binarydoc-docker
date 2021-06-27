#!/bin/bash
set -e

# Init MySQL login path
#  - https://stackoverflow.com/questions/42232310/pass-password-to-mysql-config-editor-using-variable-in-shell
host=binarydoc-db
user=root
pass=$MYSQL_ROOT_PASSWORD

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
echo "`date` Waiting for DB to be Ready ..."
while ! mysqladmin --login-path=binarydocjvmadm ping -h binarydoc-db --silent; do
  echo "`date` DB Server is NOT ready yet"
  sleep 1
done
echo "`date` DB Server is ready now"
sleep 3

echo "`date` Create DB Users if not exist"
mysql --login-path=binarydocjvmadm  <  /opt/fuiny/binarydoc-db/create-users.sql

echo "`date` Create DB Schema for Admin if not exists"
mysql --login-path=binarydocjvmadm  <  /opt/fuiny/binarydoc-db/binarydocjvmadm/create.sql

echo "`date` Prepare Artifact Setup"
mysql --login-path=binarydocjvmadm --database="binarydocjvmadm"  <  /opt/fuiny/binarydoc-db/binarydocjvmadm/data-express-version.sql

# Update configuration
echo "`date` Update configuration"
sed -i "s/127.0.0.1/binarydoc-db/g" /opt/fuiny/binarydoc-parser/etc/binarydoc-jvm.properties
sed -i "s/localhost/binarydoc-db/g" /opt/fuiny/binarydoc-parser/etc/binarydoc-jvm.properties
sed -i "s/127.0.0.1/binarydoc-db/g" /var/www/php-library/config/dbconfig.php

echo ""
echo "`date` Database is ready at localhost:$MYSQL_PORT "
echo "`date` Database is availabe at http://127.0.0.1:$ADMINER_PORT/ "
echo "`date` BinaryDoc will be availabe at http://127.0.0.1:$BINARYDOC_PORT/ "
echo ""

echo "`date` Starting Apache2 HTTPD in foreground."
source /etc/apache2/envvars
exec /usr/sbin/apache2 -D FOREGROUND

