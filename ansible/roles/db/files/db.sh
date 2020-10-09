#!/usr/bin/env bash

set -x

mysql -uroot <<MYSQL_SCRIPT
CREATE USER 'wiki'@'%' IDENTIFIED BY 'P@ssw0rd';
CREATE DATABASE wikidatabase;
GRANT ALL PRIVILEGES ON wikidatabase.* TO 'wiki'@'localhost';
GRANT ALL PRIVILEGES ON wikidatabase.* TO 'wiki'@'%';
FLUSH PRIVILEGES;
SHOW DATABASES;
SHOW GRANTS FOR 'wiki'@'%';
MYSQL_SCRIPT