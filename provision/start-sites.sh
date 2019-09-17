#!/usr/bin/env bash

running=`docker inspect -f '{{.State.Running}}' docker-nginx 2> /dev/null`
config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

if [[ "${running}" = "true" ]]; then
    for domain in `get_sites`; do
      if [[ -f "${domain}-compose.yml" ]]; then
          docker-compose restart nginx
          docker-compose --file ${domain}-compose.yml up -d
      fi
    done
fi
