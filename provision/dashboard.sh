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
    if [[ ! -f "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
        sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
        sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"

        if [[ ! -d "/srv/www/${domain}/logs/nginx" ]]; then
            mkdir -p "/srv/www/${domain}/logs/nginx"
        fi
    fi

    if [[ ! -z "${php}" ]]; then
        if [[ "${php}" == "7.4" ]]; then
            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/7.4/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/7.4/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        elif [[ "${php}" == "8" ]]; then
            if grep -q "7.4" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.0/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/8.0/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        elif [[ "${php}" == "8.1" ]]; then
            if grep -q "7.4" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        else
            if [[ ! -f "/etc/nginx/upstream/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/upstream/upstream.conf" "/etc/nginx/upstream/${domain}.test.conf"
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/upstream/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
            fi
            
            if grep -q "7.4" "/etc/nginx/upstream/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.1/g" "/etc/nginx/upstream/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/nginx/upstream/${domain}.test.conf"
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