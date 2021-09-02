#!/usr/bin/env bash

config="/srv/.global/custom.yml"

get_resources() {
    local value=`cat ${config} | shyaml get-value resources`
    echo ${value:$@}
}

repo="https://github.com/benlumia007/sturdy-docker-resources.git"
dir="resources"

resources=`get_resources`

for name in ${resources//- /$'\n'}; do
    if [[ false != ${name} && false != ${repo} ]]; then
        if [[ ! -d ${dir}/.git ]]; then
            git clone --branch new ${repo} ${dir} -q
        else
            cd ${dir}
            git pull  -q
            cd /app
        fi
    fi

    source ${dir}/${name}/setup.sh
done