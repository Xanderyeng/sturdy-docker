#!/usr/bin/env bash

server=$1

if [[ ${server} == 'nginx' ]]; then
    sudo service nginx reload > /dev/null 2>&1

else
    sudo service apache2 reload > /dev/null 2>&1
fi