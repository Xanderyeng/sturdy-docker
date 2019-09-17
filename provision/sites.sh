#!/bin/bash

domain=${sites}
repo="https://github.com/benlumia007/docker-for-wordpress-sites.git"
dir="sites/${sites}"

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
