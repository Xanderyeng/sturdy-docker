#!/usr/bin/env bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "templates/docker-setup.yml" "config/docker-custom.yml"
    cp "templates/docker-compose.yml" "docker-compose.yml"
fi

config="config/docker-custom.yml"

source provision/dashboard.sh

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for sites in `get_sites`; do
    provision=`cat ${config} | shyaml get-value sites.${sites}.provision`

    if [[ "True" == ${provision} ]]; then
        source provision/sites.sh
    else
        echo "${sites} will not be provision."
    fi
done

source provision/resources.sh