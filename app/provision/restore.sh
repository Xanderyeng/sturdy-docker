#!/bin/bash
config="/srv/.global/custom.yml"
compose="/srv/.global/docker-compose.yml"

db_restores=`cat ${config} | shyaml get-value options.db_restores 2> /dev/null`

if [[ ${db_restores} != "False" ]]; then
    cd /srv/databases
    count=$(ls -1 *.sql 2>/dev/null | wc -l)

    if [[ ${count} != 0 ]]; then
      for file in $( ls *.sql ); do
        database=${file%%.sql}

        mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${database};"
        mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON ${database}.* to 'wordpress'@'%' WITH GRANT OPTION;"
        mysql -u root -e "FLUSH PRIVILEGES;"

        exists=`mysql -u root -e "SHOW TABLES FROM ${database};"`

        if [[ "" == ${exists} ]]; then
            mysql -u root ${database} < ${database}.sql
        fi
      done
    fi
fi