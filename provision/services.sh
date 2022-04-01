#!/usr/bin/env bash

# server nginx or apache2
server=$1

if [[ ${server} == 'nginx' ]]; then
    sudo service nginx reload > /dev/null 2>&1
elif [[ ${server} == 'apache2' ]]; then
    sudo service apache2 reload > /dev/null 2>&1
fi