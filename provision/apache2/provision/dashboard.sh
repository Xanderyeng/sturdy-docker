#!/usr/bin/env bash

repo="https://github.com/benlumia007/sturdy-docker-dashboard.git"
dir="/srv/www/dashboard/public_html"

# noroot
#
# noroot allows provision scripts to be run as the default user "vagrant" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "www-data" "$@";
}

if [[ ! -d "/etc/apache2/sites-available/dashboard.conf" ]]; then
  cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/dashboard.conf"
  sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/apache2/sites-available/dashboard.conf"
  a2ensite "dashboard" > /dev/null 2>&1
fi

if [[ false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        noroot git clone ${repo} ${dir} -q
    else
        cd ${dir}
        noroot git pull -q
        cd /app
    fi
fi