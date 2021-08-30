#!/usr/bin/env bash

config="/srv/.global/custom.yml"

# noroot
#
# noroot allows provision scripts to be run as the default user "www-data" rather than the root
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

    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_repo() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.repo 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_type() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.type 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_plugins() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.plugins 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_themes() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.themes 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_constants() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.constants 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_php() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.custom.php 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`
    repo=`get_site_repo`
    type=`get_site_type`
    plugins=`get_site_plugins`
    themes=`get_site_themes`
    constants=`get_site_constants`
    php=`get_site_php`

    if [[ "True" == ${provision} ]]; then

        if [[ ! -f "/etc/apache2/sites-available/${domain}.conf" ]]; then

            cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/${domain}.conf"
            sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.conf"

            if [[ "laravel" == ${domain} ]]; then
                sed -i -e "s/public_html/public_html\/public/g" "/etc/apache2/sites-available/${domain}.conf"
            fi
            
            a2ensite "${domain}" > /dev/null 2>&1
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
            noroot git clone ${repo} ${dir}/provision -q
        else
            cd ${dir}/provision
            noroot git pull -q
            cd /app
        fi

        if [[ -d ${dir} ]]; then
            if [[ -f ${dir}/provision/setup.sh ]]; then
               source ${dir}/provision/setup.sh
            fi
        fi
    fi
done