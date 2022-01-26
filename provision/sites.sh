#!/usr/bin/env bash

domain=$1
provision=$2
repo=$3
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
    if [[ ! -f "/etc/apache2/sites-available/${domain}.conf" ]]; then

        sudo cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/${domain}.conf"
        sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.conf"

        if [[ "laravel" == ${domain} ]]; then
            sudo sed -i -e "s/public_html/public_html\/public/g" "/etc/apache2/sites-available/${domain}.conf"
        fi

        sudo a2ensite "${domain}" > /dev/null 2>&1
    fi

    if [[ ! -z "${php}" ]]; then
        if [[ ${php} == "8.0" ]]; then
            if grep -q "7.4" "/etc/nginx/conf.d/${domain}.conf"; then
                sudo sed -i -e "s/7.4/${php}/g" "/etc/nginx/conf.d/${domain}.conf"
            fi
        fi
    else
        if grep -q "8.0" "/etc/nginx/conf.d/${domain}.conf"; then
            sudo sed -i -e "s/8.0/7.4/g" "/etc/nginx/conf.d/${domain}.conf"
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
