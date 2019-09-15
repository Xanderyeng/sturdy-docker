#!/usr/bin/env bash

repo="https://github.com/benlumia007/docker-for-wordpress-dashboard.git"
dir="sites/dashboard/public_html"

if [[ ! -d "${dir}" ]]; then
    mkdir -p "config/nginx"
    cp "templates/nginx.conf" "config/nginx/dashboard.conf"
    sed -i -e "s/{{DOMAIN}}/dashboard/g" "config/nginx/dashboard.conf"
    sed -i -e "s/{{DOMAIN}}/dashboard.test/g" "config/nginx/dashboard.conf"
    rm -rf "config/nginx/dashboard.conf-e"
fi

if [[ false != "dashboard" && false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone ${repo} ${dir} -q
    else
        cd ${dir}
        git pull -q
        cd ../../..
    fi 
fi

if [[ -d "${dir}" ]]; then
    mkdir -p "sites/dashboard/public_html/config"
    cp "config/docker-custom.yml" "sites/dashboard/public_html/config/docker-custom.yml"
fi