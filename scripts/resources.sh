#!/usr/bin/env bash

config=".global/docker-custom.yml"

get_repo() {
    local value=`cat ${config} | shyaml get-value resources.repo`
    echo ${value:$@}
}

get_resources() {
    local value=`cat ${config} | shyaml get-value resources.utilities`
    echo ${value:$@}
}

repo=`get_repo`
dir="scripts/resources"
resources=`get_resources`

for name in ${resources//- /$'\n'}; do
    if [[ false != ${name} && false != ${repo} ]]; then
        if [[ ! -d ${dir}/.git ]]; then
            git clone ${repo} ${dir} -q
        else
            cd ${dir}
            git pull origin master -q
            cd ../..
        fi
    fi

    source ${dir}/${name}/setup.sh
done
