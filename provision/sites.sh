#!/bin/bash

config=".global/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_repo() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.repo 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`
    repo=`get_site_repo`

    if [[ "True" == ${provision} ]]; then
        dir="sites/${domain}"

        if [[ false != "${repo}" ]]; then
            if [[ ! -d "${dir}/provision/.git" ]]; then
                git clone ${repo} ${dir}/provision -q
            else
                cd "${dir}/provision"
                git pull origin master -q
                cd ../../..
            fi
        fi

        if [[ -d ${dir} ]]; then
            if [[ -f ${dir}/provision/setup.sh ]]; then
                source ${dir}/provision/setup.sh
            fi
        fi
    fi
done
