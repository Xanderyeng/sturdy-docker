#!/usr/bin/env bash

domain=$1
provision=$2
repo=$3
dir=$4
config=$5

get_custom_value() {
    local value=`cat ${config} | shyaml get-value sites.${domain}.custom.${1} 2> /dev/null`
    echo ${value:-$@}
}

type=`get_custom_value 'type' ''`
ms=`get_custom_value 'multisite' ''`
plugins=`get_custom_value 'plugins' ''`
themes=`get_custom_value 'themes' ''`
constants=`get_custom_value 'constants' ''`
php=`get_custom_value 'php' ''`

if [[ ${provision} == 'true' ]]; then
    if [[ ! -z "${type}" ]]; then
        if [[ "${type}" == 'jigsaw' ]] || [[ "${type}" == 'Jigsaw' ]]; then
            if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/nginx/jigsaw/default.conf" "/etc/nginx/conf.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        elif [[ "${type}" == 'laravel' ]] || [[ "${type}" == 'Laravel' ]]; then
            if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
                sudo sed -i -e "s/public_html/public_html\/public/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        elif [[ "${type}" == 'WordPress' ]] || [[ "${type}" == 'wordpress' ]]; then
            if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        elif [[ "${type}" == 'ClassicPress' ]] || [[ "${type}" == 'classicpress' ]]; then
            if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        else 
            if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        fi
    fi

    if [[ ! -d "/srv/www/${domain}/logs/nginx" ]]; then
        mkdir -p "/srv/www/${domain}/logs/nginx"
    fi

    if [[ ! -d "/srv/www/${domain}/logs/php" ]]; then
        mkdir -p "/srv/www/${domain}/logs/php"
    fi

    if [[ ! -z "${php}" ]]; then
        if [[ "${php}" == "7.4" ]]; then
            if [[ ! -f "/etc/nginx/upstream/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/upstream/upstream.conf" "/etc/nginx/upstream/${domain}.test.conf"
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/7.4/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/upstream/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/7.4/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/8.1/7.4/g" "/etc/nginx/upstream/${domain}.test.conf"
                sudo sed -i -e "s/8.1/7.4/g" "/etc/php/7.4/fpm/pool.d/${domain}.test.conf"
            fi

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
            if grep -q "7.4" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        fi
    fi

    if [[ ! -d "${dir}/provision/.git" ]]; then
        git clone --branch main ${repo} ${dir}/provision -q
    else
        cd ${dir}/provision
        git pull -q
        cd /app
    fi

    if [[ -d ${dir} ]]; then
        if [[ -f ${dir}/provision/setup.sh ]]; then
            source ${dir}/provision/setup.sh
        fi
    fi
else 
    sudo rm -rf "/etc/nginx/conf.d/${domain}.test.conf"
fi