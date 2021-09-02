#!/usr/bin/env bash

repo="https://github.com/benlumia007/sturdy-docker-dashboard.git"
dir="/srv/www/dashboard/public_html"

if [[ ! -d "/etc/apache2/sites-available/dashboard.conf" ]]; then
  sudo cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/dashboard.conf"
  sudo sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/apache2/sites-available/dashboard.conf"
  sudo a2ensite "dashboard" > /dev/null 2>&1
fi

if [[ false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone --branch main ${repo} ${dir} -q
        cd ${dir}
        composer install -q
        cd /app
    else
        cd ${dir}
        git pull origin main -q
        cd /app
    fi
fi