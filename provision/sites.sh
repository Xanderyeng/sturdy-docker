#!/usr/bin/env bash

server=$1
domain=$2
provision=$3
repo=$4
php=$5
dir=$6
config=$7

get_custom_value() {
    local value=`cat ${config} | shyaml get-value sites.${domain}.custom.${1} 2> /dev/null`
    echo ${value:-$@}
}

type=`get_custom_value 'type' ''`
ms=`get_custom_value 'multisite' ''`
plugins=`get_custom_value 'plugins' ''`
themes=`get_custom_value 'themes' ''`
constants=`get_custom_value 'constants' ''`

if [[ ${provision} == 'true' ]]; then
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
        
        if [[ "${php}" == "8.1" ]]; then
            if grep -q "7.4" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/nginx/conf.d/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/nginx/conf.d/${domain}.test.conf"
            fi
        fi
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