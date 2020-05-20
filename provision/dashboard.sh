#!/usr/bin/env bash

repo="https://github.com/benlumia007/docker-for-wordpress-dashboard.git"
dir="sites/dashboard/public_html"

if [[ ! -d "${dir}" ]]; then
    mkdir -p "config/nginx"
    cp "config/templates/nginx.conf" "config/nginx/dashboard.conf"
    sed -i -e "s/{{DOMAIN}}/dashboard/g" "config/nginx/dashboard.conf"
    sed -i -e "s/{{DOMAIN}}/dashboard.test/g" "config/nginx/dashboard.conf"
    rm -rf "config/nginx/dashboard.conf-e"

    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        if ! grep -q "dashboard.test" /mnt/c/Windows/System32/drivers/etc/hosts; then
            echo "127.0.0.1   dashboard.test" | sudo tee -a /mnt/c/Windows/System32/drivers/etc/hosts
        fi
    else
        if ! grep -q "dashboard.test" /etc/hosts; then
            echo "127.0.0.1   dashboard.test" | sudo tee -a /etc/hosts
        fi
    fi


fi

if [[ false != "${repo}" ]]; then
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
    cp ".global/docker-custom.yml" "sites/dashboard/public_html/config/docker-custom.yml"
fi
