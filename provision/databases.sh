#!/bin/bash
config="/srv/.global/custom.yml"
compose="/srv/.global/docker-compose.yml"

db_restores=$2


get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    get_custom_value() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.${1} 2> /dev/null`
        echo ${value:-$@}
    }

    get_provision() {
      local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
      echo ${value:-$@}
    }

    type=`get_custom_value 'type' ''`
    provision=`get_provision 'provision' ''`
    subdomains=`get_custom_value 'subdomains' ''`

    if [[ ${provision} != "False" ]]; then
        if [[ "${type}" == "ClassicPress" || "${type}" == "classicpress" ]]; then
            mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
            mysql -u root -e "CREATE USER IF NOT EXISTS 'classicpress'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'classicpress';"
            mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'classicpress'@'localhost' WITH GRANT OPTION;"
            mysql -u root -e "FLUSH PRIVILEGES;"

            for sub in ${subdomains//- /$'\n'}; do
                if [[ "${sub}" != "subdomains" ]]; then
                      mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain}_${sub};"
                      mysql -u root -e "CREATE USER IF NOT EXISTS 'classicpress'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'classicpress';"
                      mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}_${sub}.* to 'classicpress'@'localhost' WITH GRANT OPTION;"
                      mysql -u root -e "FLUSH PRIVILEGES;"
                fi
            done
        elif [[ ${type} == "WordPress" || "${type}" == "wordpress" ]]; then
            mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
            mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
            mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'wordpress'@'localhost' WITH GRANT OPTION;"
            mysql -u root -e "FLUSH PRIVILEGES;"

            for sub in ${subdomains//- /$'\n'}; do
                if [[ "${sub}" != "subdomains" ]]; then
                      mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain}_${sub};"
                      mysql -u root -e "CREATE USER IF NOT EXISTS 'classicpress'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'classicpress';"
                      mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}_${sub}.* to 'classicpress'@'localhost' WITH GRANT OPTION;"
                      mysql -u root -e "FLUSH PRIVILEGES;"
                fi
            done
        fi
    fi
done

if [[ ${db_restores} != "false" ]]; then
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
