#!/bin/bash

domain=${sites}
repo="https://github.com/benlumia007/docker-for-wordpress-sites.git"
dir="sites/${domain}"

if [[ false != "${repo}" ]]; then
    if [[ ! -d "${dir}/provision/.git" ]]; then
        git clone ${repo} ${dir}/provision -q
    else
        git pull origin master -q
    fi
fi

if [[ -d ${dir} ]]; then
    if [[ -f ${dir}/provision/setup.sh ]]; then
        cd ${dir}/provision && source setup.sh
    fi
fi