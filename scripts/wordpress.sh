#!/usr/bin/env bash

config=".global/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml get-value sites.domain 2> /dev/null`
    echo ${value:-$@}
}

domains=`get_sites`

for domain in ${domains//- /$'\n'}; do
    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.provision 2> /dev/null`
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

            docker-compose -f ${compose} exec -T nginx wp core download --path="${path}" --quiet --allow-root
            docker-compose -f ${compose} exec -T nginx wp config create --dbhost=mysql --dbname=${domain} --dbuser=wordpress --dbpass=wordpress --path="${path}" --quiet --allow-root
            docker-compose -f ${compose} exec -T nginx wp core install  --url="https://${domain}.test" --title="${domain}.test" --admin_user=admin --admin_password=password --admin_email="admin@${domain}.test" --skip-email --quiet --path=${path} --allow-root
            docker-compose -f ${compose} exec -T nginx wp plugin delete akismet --path=${path} --quiet --allow-root
            docker-compose -f ${compose} exec -T nginx wp plugin delete hello --path=${path} --quiet --allow-root
            docker-compose -f ${compose} exec -T nginx wp config shuffle-salts --path=${path} --quiet --allow-root

            docker-compose -f ${compose} exec -T nginx chown -R 1000:1000 ${path}
        fi
    fi
done
