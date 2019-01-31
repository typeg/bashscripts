#!/bin/bash

DB_HOME=/app/myapp/db/mysql
DB_PASS=myapp
DB_SCHEMA=myappservice
VAULT_HOME=/app/myapp/vault
HOSTNAME=$(hostname -s)

if $DB_HOME/bin/mysqlshow --socket=$DB_HOME/log/mysqld.sock -u myapp -p$DB_PASS 2> /dev/null | grep -q $DB_SCHEMA; then
        echo "ONLINE" > $VAULT_HOME/share/db_status_$HOSTNAME.txt
else
        echo "OFFLINE" > $VAULT_HOME/share/db_status_$HOSTNAME.txt
fi