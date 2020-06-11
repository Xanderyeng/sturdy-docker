#!/usr/bin/env bash

repo="https://github.com/benlumia007/wp-4-docker-dashboard.git"
dir="/srv/www/dashboard/public_html"

if [[ ! -d "/etc/nginx/conf.d/dashboard.conf" ]]; then
  sudo cp "/app/config/templates/nginx.conf" "/etc/nginx/conf.d/dashboard.conf"
  sudo sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/nginx/conf.d/dashboard.conf"
fi

if [[ false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone ${repo} ${dir} -q
    else
        cd ${dir}
        git pull -q
        cd /app
    fi
fi
