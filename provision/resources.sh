#!/usr/bin/env bash

name=$1
repo=$2
config="/srv/.global/custom.yml"
dir="resources"

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