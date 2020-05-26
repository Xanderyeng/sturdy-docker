#!/usr/bin/env bash

config=".global/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`

    if [[ "True" == ${provision} ]]; then
        dir="sites/${domain}/public_html"
        path="/srv/www/${domain}/public_html"

        compose=".global/docker-compose.yml"

        if [[ ! -f "${dir}/wp-config.php" ]]; then
            docker-compose -f ${compose} exec -T mysql mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
            docker-compose -f ${compose} exec -T mysql mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
            docker-compose -f ${compose} exec -T mysql mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'wordpress'@'%' WITH GRANT OPTION;"
            docker-compose -f ${compose} exec -T mysql mysql -u root -e "FLUSH PRIVILEGES;"

            docker-compose -f ${compose} exec -T nginx wp core download --path="${path}" --allow-root
            docker-compose -f ${compose} exec -T nginx wp config create --dbhost=mysql --dbname=${domain} --dbuser=wordpress --dbpass=wordpress --path="${path}" --allow-root
            docker-compose -f ${compose} exec -T nginx wp core install  --url="https://${domain}.test" --title="${domain}.test" --admin_user=admin --admin_password=password --admin_email="admin@${domain}.test" --path=${path} --allow-root
            docker-compose -f ${compose} exec -T nginx wp plugin delete akismet --path=${path} --allow-root
            docker-compose -f ${compose} exec -T nginx wp plugin delete hello --path=${path} --allow-root
            docker-compose -f ${compose} exec -T nginx wp config shuffle-salts --path=${path} --allow-root

            docker-compose -f ${compose} exec -T nginx chown -R 1000:1000 ${path}
        fi
    fi
done
