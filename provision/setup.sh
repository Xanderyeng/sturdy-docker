#!/bin/bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "templates/docker-setup.yml" "config/docker-custom.yml"
    cp "templates/docker-compose.yml" "docker-compose.yml"
fi

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for sites in `get_sites`; do
    source provision/sites.sh
done