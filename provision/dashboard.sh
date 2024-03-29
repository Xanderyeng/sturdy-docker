#!/usr/bin/env bash

domain=$1
provision=$2
repo=$3
dir=$4
config=$5

get_default_value() {
    local value=`cat ${config} | shyaml get-value default.${domain}.custom.${1} 2> /dev/null`
    echo ${value:-$@}
}

php=`get_default_value 'php' ''`

if [[ "${provision}" == 'true' ]]; then
    if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
        sudo cp "/srv/config/apache2/default.conf" "/etc/apache2/sites-available/${domain}.test.conf"
        sudo sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/apache2/sites-available/${domain}.test.conf"
        sudo a2ensite "${domain}.test" > /dev/null 2>&1
    fi

    if [[ ! -d "/srv/www/${domain}/logs/apache2" ]]; then
        mkdir -p "/srv/www/${domain}/logs/apache2"
    fi

    if [[ ! -d "/srv/www/${domain}/logs/php" ]]; then
        mkdir -p "/srv/www/${domain}/logs/php"
    fi

    if [[ ! -z "${php}" ]]; then
        if [[ "${php}" == '8' ]] || [[ "${php}" == '8.0' ]]; then
            if [[ ! -f "/etc/php/8.0/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.0/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.0/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/8.1/8.0/g" "/etc/php/8.0/fpm/pool.d/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/8.0/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        elif [[ "${php}" == "8.1" ]]; then
            if [[ ! -f "/etc/php/8.1/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
            fi
            
            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        else
            if [[ ! -f "/etc/php/8.1/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
            fi
            
            if grep -q "8.0" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        fi
    fi
fi

if [[ false != "${repo}" ]]; then
    if [[ ! -d "${dir}/public_html/.git" ]]; then
        git clone --branch main ${repo} "${dir}/public_html" -q
        cd "${dir}/public_html"
        composer install -q
        cd "/app"
    else
        cd "${dir}/public_html"
        git pull origin main -q
        cd "/app"
    fi
fi