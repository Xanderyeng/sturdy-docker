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
subdomains=`get_custom_value 'subdomains' ''`

if [[ ${provision} == 'true' ]]; then
    if [[ ! -z "${type}" ]]; then
        if [[ "${type}" == 'blush' ]] || [[ "${type}" == 'Blush' ]]; then
            if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/apache2/default.conf" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo a2ensite "${domain}.test" > /dev/null 2>&1
            fi

            for sub in ${subdomains//- /$'\n'}; do
                if [[ "${sub}" != "subdomains" ]]; then
                    if [[ ! -f "/etc/apache2/sites-available/${sub}.${domain}.test.conf" ]]; then
                        sudo cp "/srv/config/apache2/subdomains.conf" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo sed -i -e "s/{{SUBDOMAIN}}.{{DOMAIN}}/${sub}.${domain}/g" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo sed -i -e "s/{{SUBDOMAIN}}/${sub}/g" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo a2ensite "${sub}.${domain}.test" > /dev/null 2>&1
                    fi

                    if [[ ! -d "/srv/www/${domain}/domains/${sub}/public_html" ]]; then
                        mkdir -p "/srv/www/${domain}/domains/${sub}/public_html"
                    fi
                fi
            done
        elif [[ "${type}" == 'classicpress' ]] || [[ "${type}" == 'ClassicPress' ]]; then
            if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/apache2/default.conf" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo a2ensite "${domain}.test" > /dev/null 2>&1
            fi

            for sub in ${subdomains//- /$'\n'}; do
                if [[ "${sub}" != "subdomains" ]]; then
                    if [[ ! -f "/etc/apache2/sites-available/${sub}.${domain}.test.conf" ]]; then
                        sudo cp "/srv/config/apache2/subdomains.conf" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo sed -i -e "s/{{SUBDOMAIN}}.{{DOMAIN}}/${sub}.${domain}/g" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo sed -i -e "s/{{SUBDOMAIN}}/${sub}/g" "/etc/apache2/sites-available/${sub}.${domain}.test.conf"
                        sudo a2ensite "${sub}.${domain}.test" > /dev/null 2>&1
                    fi

                    if [[ ! -d "/srv/www/${domain}/domains/${sub}/public_html" ]]; then
                        mkdir -p "/srv/www/${domain}/domains/${sub}/public_html"
                    fi
                fi
            done
        elif [[ "${type}" == 'jigsaw' ]] || [[ "${type}" == 'Jigsaw' ]]; then
            if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/apache2/default.conf" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/public_html/public_html\/build_local/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo a2ensite "${domain}.test" > /dev/null 2>&1
            fi
        elif [[ "${type}" == 'laravel' ]] || [[ "${type}" == 'Laravel' ]]; then
            if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/apache2/default.conf" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/public_html/public_html\/public/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo a2ensite "${domain}.test" > /dev/null 2>&1
            fi
        elif [[ "${type}" == 'WordPress' ]] || [[ "${type}" == 'wordpress' ]]; then
            if [[ ! -d "/etc/apache2/sites-available/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/apache2/default.conf" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.test.conf"
                sudo a2ensite "${domain}.test" > /dev/null 2>&1
            fi
        fi
    fi

    if [[ ! -d "/srv/www/${domain}/logs/apache2" ]]; then
        mkdir -p "/srv/www/${domain}/logs/apache2"
    fi

    if [[ ! -d "/srv/www/${domain}/logs/php" ]]; then
        mkdir -p "/srv/www/${domain}/logs/php"
    fi

    if [[ ! -z "${php}" ]]; then
        if [[ "${php}" == "7.4" ]]; then
            if [[ ! -f "/etc/php/7.4/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/7.4/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/7.4/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/8.1/7.4/g" "/etc/php/7.4/fpm/pool.d/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/7.4/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/7.4/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi
        elif [[ "${php}" == '8' ]] || [[ "${php}" == '8.0' ]]; then
            if [[ ! -f "/etc/php/8.0/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.0/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.0/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/8.1/8.0/g" "/etc/php/8.0/fpm/pool.d/${domain}.test.conf"
            fi

            if grep -q "7.4" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.0/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi

            if grep -q "8.1" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/8.1/8.0/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi
        elif [[ "${php}" == "8.1" ]]; then
            if [[ ! -f "/etc/php/8.1/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
            fi

            if grep -q "7.4" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.1/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi
        else
            if [[ ! -f "/etc/php/8.1/fpm/pool.d/${domain}.test.conf" ]]; then
                sudo cp "/srv/config/php/fpm/fpm.conf" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
                sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/php/8.1/fpm/pool.d/${domain}.test.conf"
            fi

            if grep -q "7.4" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/7.4/8.1/g" "/etc/apache2/sites-available/${domain}.test.conf"
            fi

            if grep -q "8.0" "/etc/apache2/sites-available/${domain}.test.conf"; then
                sudo sed -i -e "s/8.0/8.1/g" "/etc/apache2/sites-available/${domain}.test.conf"
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
    sudo rm -rf "/etc/apache2/sites-available/${domain}.test.conf"
fi
