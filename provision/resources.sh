#!/usr/bin/env bash

name=$1
repo=$2
custom=$3
dir=$4

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