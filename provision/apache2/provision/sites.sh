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

    if [[ ! -f "/etc/apache2/sites-available/${domain}.conf" ]]; then
      if [[ "laravel" == "${domain}" ]]; then
        cp "/srv/config/apache2/laravel.conf" "/etc/apache2/sites-available/${domain}.conf"
        else
        cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/${domain}.conf"
      fi
      sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.conf"
      a2ensite "${domain}" > /dev/null 2>&1
    fi


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

    provision=`get_site_provision`
    repo=`get_site_repo`
    type=`get_site_type`
    plugins=`get_site_plugins`
    themes=`get_site_themes`
    constants=`get_site_constants`

    if [[ "True" == ${provision} ]]; then
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