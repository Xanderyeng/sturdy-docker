#!/usr/bin/env bash

name=$1
repo=$2
config="/srv/.global/custom.yml"
dir="/app/resources"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`

    if [[ ${provision} == "True" ]]; then 
        if [[ ! -z ${name} && ! -z ${repo} ]]; then
            if [[ ! -d ${dir}/.git ]]; then
                git clone --branch main ${repo} ${dir} -q
            else
                cd ${dir}
                git pull  -q
                cd /app
            fi
        fi

        source ${dir}/${name}/setup.sh
    fi
done