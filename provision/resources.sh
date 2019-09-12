#!/usr/bin/env bash

config="config/docker-custom.yml"

get_resources() {
    local value=`cat ${config} | shyaml get-value resources`
    echo ${value:$@}
}

repo="git@github.com:benlumia007/docker-for-wordpress-resources.git"
dir="provision/resources/${name}"

if [[ false != ${name} && false != ${repo} ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone ${repo} ${dir} -q
    else
        cd ${dir}
        git pull origin master -q
    fi
fi

