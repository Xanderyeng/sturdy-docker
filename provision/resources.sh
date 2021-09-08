#!/usr/bin/env bash

name=$1
repo=$2
config="/srv/.global/custom.yml"
dir="resources"

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
