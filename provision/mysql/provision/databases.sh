#!/bin/bash
config="/srv/.global/custom.yml"
compose="/srv/.global/docker-compose.yml"

db_restores=`cat ${config} | shyaml get-value options.db_restores 2> /dev/null`

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    get_site_cms_type() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.type 2> /dev/null`
        echo ${value:-$@}
    }

    type=`get_site_cms_type`

    if [[ "ClassicPress" == ${type} ]]; then
        mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
        mysql -u root -e "CREATE USER IF NOT EXISTS 'classicpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'classicpress';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'classicpress'@'%' WITH GRANT OPTION;"
        mysql -u root -e "FLUSH PRIVILEGES;"
    else
        mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
        mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'wordpress'@'%' WITH GRANT OPTION;"
        mysql -u root -e "FLUSH PRIVILEGES;"
    fi
done

if [[ ${db_restores} != "False" ]]; then
    cd /srv/databases
    count=$(ls -1 *.sql 2>/dev/null | wc -l)

    if [[ ${count} != 0 ]]; then
        for file in $( ls *.sql ); do
          database=${file%%.sql}

          exists=`mysql -u root -e "SHOW TABLES FROM ${database};"`

          if [[ "" == ${exists} ]]; then
              mysql -u root ${database} < ${database}.sql
          fi
        done
    fi
fi