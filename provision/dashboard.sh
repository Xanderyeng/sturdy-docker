#!/usr/bin/env bash

server=$1
domain=$2
provision=$3
repo=$4
php=$5
dir=$6

if [[ ${server} == 'nginx' ]]; then
    if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
        sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
        sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
    fi

    if [[ ! -z "${php}" ]]; then
        if [[ "${php}" == "7.4" ]]; then
            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/7.4/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/7.4/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        fi

        if [[ "${php}" == "8" ]]; then
            if grep -q "7.4" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.0/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/8.0/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        fi
    fi
elif [[ ${server} == 'apache2' ]]; then 
    if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
        sudo cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/${domain}.test.conf"
        sudo sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/apache2/sites-available/${domain}.test.conf"
        sudo a2ensite "${domain}.test" > /dev/null 2>&1
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