#!/usr/bin/env bash

config=".global/docker-custom.yml"

repo="https://github.com/benlumia007/docker-for-wordpress-dashboard.git"
dir="sites/dashboard/public_html"

get_preprocessor() {
    local value=`cat ${config} | shyaml get-value preprocessor 2> /dev/null`
    echo ${value:-$@}
}

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

preprocessors=`get_preprocessor`

for php in ${preprocessors//- /$'\n'}; do

    if [[ ${php} == "7.2" ]]; then
        if grep -q "7.3" config/nginx/dashboard.conf; then
            sed -i -e "s/7.3/${php}/g" "config/nginx/dashboard.conf"
        elif grep -q "7.4" config/nginx/dashboard.conf; then
            sed -i -e "s/7.4/${php}/g" "config/nginx/dashboard.conf"
        else
            sed -i -e "s/{{PHPVERSION}}/${php}/g" "config/nginx/dashboard.conf"
        fi
    elif [[ ${php} == "7.3" ]]; then
        if grep -q "7.2" config/nginx/dashboard.conf; then
            sed -i -e "s/7.2/${php}/g" "config/nginx/dashboard.conf"
        elif grep -q "7.4" config/nginx/dashboard.conf; then
            sed -i -e "s/7.4/${php}/g" "config/nginx/dashboard.conf"
        else
            sed -i -e "s/{{PHPVERSION}}/${php}/g" "config/nginx/dashboard.conf"
        fi
    elif [[ ${php} == "7.4" ]]; then
        if grep -q "7.2" config/nginx/dashboard.conf; then
            sed -i -e "s/7.2/${php}/g" "config/nginx/dashboard.conf"
        elif grep -q "7.3" config/nginx/dashboard.conf; then
            sed -i -e "s/7.3/${php}/g" "config/nginx/dashboard.conf"
        else
            sed -i -e "s/{{PHPVERSION}}/${php}/g" "config/nginx/dashboard.conf"
        fi
    fi

done

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
