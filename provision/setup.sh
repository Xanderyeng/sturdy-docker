#!/usr/bin/env bash

config=".global/docker-custom.yml"

if [[ ! -f ".global/docker-custom.yml" ]]; then
    cp "config/templates/docker-compose.tmpl" ".global/docker-compose.yml"
    cp "config/templates/docker-setup.yml" ".global/docker-custom.yml"
fi

get_preprocessor() {
    local value=`cat ${config} | shyaml get-value preprocessor 2> /dev/null`
    echo ${value:-$@}
}

preprocessors=`get_preprocessor`

for php in ${preprocessors//- /$'\n'}; do
 
     if [[ ! -f ".global/docker-compose.yml" ]]; then
        cp "config/templates/docker-compose.tmpl" ".global/docker-compose.yml"
    fi

    if [[ ${php} == "7.2" ]]; then
        if grep -q "7.3" .global/docker-compose.yml; then
            sed -i -e "s/7.3/${php}/g" ".global/docker-compose.yml"
        elif grep -q "7.4" .global/docker-compose.yml; then
            sed -i -e "s/7.4/${php}/g" ".global/docker-compose.yml"
        else
            sed -i -e "s/{{PHPVERSION}}/${php}/g" ".global/docker-compose.yml"
        fi
    elif [[ ${php} == "7.3" ]]; then
        if grep -q "7.2" .global/docker-compose.yml; then
            sed -i -e "s/7.2/${php}/g" ".global/docker-compose.yml"
        elif grep -q "7.4" .global/docker-compose.yml; then
            sed -i -e "s/7.4/${php}/g" ".global/docker-compose.yml"
        else
            sed -i -e "s/{{PHPVERSION}}/${php}/g" ".global/docker-compose.yml"
        fi
    elif [[ ${php} == "7.4" ]]; then
        if grep -q "7.2" .global/docker-compose.yml; then
            sed -i -e "s/7.2/${php}/g" ".global/docker-compose.yml"
        elif grep -q "7.3" .global/docker-compose.yml; then
            sed -i -e "s/7.3/${php}/g" ".global/docker-compose.yml"
        else
            sed -i -e "s/{{PHPVERSION}}/${php}/g" ".global/docker-compose.yml"
        fi
    fi

done