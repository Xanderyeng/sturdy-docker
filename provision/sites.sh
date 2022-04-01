#!/usr/bin/env bash

server=$1
domain=$2
provision=$3
repo=$4
config="/srv/.global/custom.yml"
dir="/srv/www/${domain}"

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
    if [[ ${server} == 'nginx' ]]; then
        if [[ ! -d "/etc/nginx/conf.d/${domain}.test.conf" ]]; then
            sudo cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/${domain}.test.conf"
            sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.test.conf"
        fi
    elif [[ ${server} == 'apache2' ]]; then 
        if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
        sudo cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/${domain}.test.conf"
        sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.test.conf"
        sudo a2ensite "${domain}.test" > /dev/null 2>&1
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
fi