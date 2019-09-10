#!/bin/bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    docker exec -it docker-mysql mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
    docker exec -it docker-mysql mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
    docker exec -it docker-mysql mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'wordpress'@'%' WITH GRANT OPTION;"
    docker exec -it docker-mysql mysql -u root -e "FLUSH PRIVILEGES;"

    docker exec -it docker-sandbox wp core install  --url="https://${domain}.test" --title="${domain}.test" --admin_user=admin --admin_password=password --admin_email="admin@${domain}.test" --allow-root
done