#!/usr/bin/env bash
config=${PWD}/.global/docker-custom.yml
dir=${PWD}/sites/dashboard/public_html

repo="https://github.com/benlumia007/docker-for-wordpress-dashboard.git"

if [[ false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        git clone ${repo} ${dir} -q
    else
        cd ${dir}
        git pull -q
        cd ../../..
    fi
fi