#!/usr/bin/env bash
config=${PWD}/.global/docker-custom.yml
dir=${PWD}/sites/dashboard/public_html


get_dashboard_repo() {
    local value=`cat ${config} | shyaml get-value default.repo`
    echo ${value:$@}
}

get_php_version() {
    local value=`cat ${config} | shyaml get-value preprocessor`
    echo ${value:$@}
}

repo=`get_dashboard_repo`
preprocessors=`get_php_version`

if [[ false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone ${repo} ${dir} -q
    else
        cd ${dir}
        git pull -q
        cd ../../..
    fi
fi

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