#!/bin/bash
config="/srv/.global/custom.yml"

db_backups=`cat ${config} | shyaml get-value options.db_backups 2> /dev/null`

if [[ ${db_backups} != "False" ]]; then
    mysql --user="root" -e 'show databases' | \
    grep -v -F "information_schema" | \
    grep -v -F "performance_schema" | \
    grep -v -F "mysql" | \
    grep -v -F "test" | \
    grep -v -F "Database" | \
    grep -v -F "sys" | \
    while read dbname;
    do
      mysqldump -u root -e "${dbname}" > "/srv/databases/${dbname}.sql";
    done
fi