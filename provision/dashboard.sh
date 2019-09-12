#!/usr/bin/env bash

repo="git@github.com:benlumia007/docker-for-wordpress-dashboard.git"
dir="sites/dashboard/public_html"

if [[ ! -d "${dir}" ]]; then
    cp "templates/nginx.conf" "config/nginx/dashboard.conf"
    sed -i -e "s/{{DOMAIN}}/dashboard/g" "config/nginx/dashboard.conf"
    rm -rf "config/nginx/dashboard.conf-e"
fi

if [[ false != "dashboard" && false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone ${repo} ${dir} -q
    else
        cd ${dir}
        git pull -q
    fi 
fi