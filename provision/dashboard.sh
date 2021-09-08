#!/usr/bin/env bash

domain=$1
provision=$2
repo=$3
dir="/srv/www/${domain}"


if [[ ! -d "/etc/apache2/sites-available/${domain}.conf" ]]; then
  sudo cp "/srv/config/apache2/apache2.conf" "/etc/apache2/sites-available/${domain}.conf"
  sudo sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/apache2/sites-available/${domain}.conf"
  sudo a2ensite "${domain}" > /dev/null 2>&1
fi

if [[ false != "${repo}" ]]; then
    if [[ ! -d "${dir}/public_html/.git" ]]; then
        git clone --branch main ${repo} "${dir}/public_html" -q
        cd "${dir}/public_html"
        composer install -q
        cd "/app"
    else
        cd "${dir}/public_html"
        git pull origin main -q
        cd "/app"
    fi
fi