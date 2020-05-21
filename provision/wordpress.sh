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
        path="/var/www/html/${domain}/public_html"

        if [[ ! -f "${dir}/wp-config.php" ]]; then
            if [[ `uname` == "Linux" ]]; then
                wp core download --path=${dir}
            fi

            cp "config/templates/wp-config.php" "${dir}/wp-config.php"
            sed -i -e "/DB_HOST/s/'[^']*'/'mysql'/2" "${dir}/wp-config.php"
            sed -i -e "/DB_NAME/s/'[^']*'/'${domain}'/2" "${dir}/wp-config.php"
            sed -i -e "/DB_USER/s/'[^']*'/'wordpress'/2" "${dir}/wp-config.php"
            sed -i -e "/DB_PASSWORD/s/'[^']*'/'wordpress'/2" "${dir}/wp-config.php"
            rm -rf "${dir}/wp-config.php-e"

            docker exec -it docker-mysql mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${domain};"
            docker exec -it docker-mysql mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
            docker exec -it docker-mysql mysql -u root -e "GRANT ALL PRIVILEGES ON ${domain}.* to 'wordpress'@'%' WITH GRANT OPTION;"
            docker exec -it docker-mysql mysql -u root -e "FLUSH PRIVILEGES;"

            docker exec -it docker-phpfpm wp core install  --url="https://${domain}.test" --title="${domain}.test" --admin_user=admin --admin_password=password --admin_email="admin@${domain}.test" --path=${path} --allow-root
            docker exec -it docker-phpfpm wp plugin delete akismet --path=${path} --allow-root
            docker exec -it docker-phpfpm wp plugin delete hello --path=${path} --allow-root
            docker exec -it docker-phpfpm wp config shuffle-salts --path=${path} --allow-root
        fi
    fi
done
