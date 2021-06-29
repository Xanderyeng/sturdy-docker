#!/usr/bin/env bash

repo="https://github.com/benlumia007/sturdy-docker-dashboard.git"
github="/srv/www/dashboard/github"
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
    if [[ ! -d ${github}/.git ]]; then
        noroot git clone --branch main ${repo} ${github} -q
        cd ${github}
        noroot composer install -q
        noroot npm install &> /dev/null
        noroot npm run build &> /dev/null
        noroot mv ${github}/public_html ${dir}
        cd /app
    else
        cd ${github}
        noroot git pull -q
        cd /app
    fi
fi