#!/usr/bin/env bash

config="config/docker-custom.yml"

get_resources() {
    local value=`cat ${config} | shyaml get-value resources.utilties`
    echo ${value:$@}
}

resources=`get_resources`

for name in ${resources//- /$'\n'}; do
    sh "provision/resources/${name}/setup.sh"
done