#!/bin/bash

config="$PWD/.global/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml get-value sites.domain 2> /dev/null`
    echo ${value:-$@}
}

domains=`get_sites`

for domain in ${domains//- /$'\n'}; do

    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.provision 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_repo() {
        local value=`cat ${config} | shyaml get-value sites.repo 2> /dev/null`
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
