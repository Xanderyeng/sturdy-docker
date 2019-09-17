#!/usr/bin/env bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "config/templates/docker-setup.yml" "config/docker-custom.yml"
    cp "config/templates/docker-compose.yml" "docker-compose.yml"
fi

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for sites in `get_sites`; do
    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${sites}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`

    if [[ "True" == ${provision} ]]; then
        source provision/sites.sh
    else
        source provision/remove-sites.sh
    fi
done


