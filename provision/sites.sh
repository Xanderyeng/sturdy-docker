#!/usr/bin/env bash

config="/srv/.global/custom.yml"

# noroot
#
# allows provision scripts to be run as the default user "www-data" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "www-data" "$@";
}


get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do

    get_primary_value() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.${1} 2> /dev/null`
        echo ${value:-$@}
    }

    get_custom_value() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.${1} 2> /dev/null`
        echo ${value:-$@}
    }   

    provision=`get_primary_value 'provision' ''`
    repo=`get_primary_value 'repo' ''`
    type=`get_custom_value 'type' ''`
    plugins=`get_custom_value 'plugins' ''`
    themes=`get_custom_value 'themes' ''`
    constants=`get_custom_value 'constants' ''`
    php=`get_custom_value 'php' ''`

    if [[ "True" == ${provision} ]]; then

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
                if grep -q "7.4" "/etc/apache2/sites-available/${domain}.conf"; then
                    sed -i -e "s/7.4/${php}/g" "/etc/apache2/sites-available/${domain}.conf"
                fi
            fi
        else 
            if grep -q "8.0" "/etc/apache2/sites-available/${domain}.conf"; then
                sed -i -e "s/8.0/7.4/g" "/etc/apache2/sites-available/${domain}.conf"
            fi
        fi

        dir="/srv/www/${domain}"
        if [[ ! -d "${dir}/provision/.git" ]]; then
            git clone --branch user-docker ${repo} ${dir}/provision -q
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
done