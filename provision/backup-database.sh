#!/usr/bin/env bash

config="config/docker-custom.yml"

get_sites() {
  local value=`cat ${config} | shyaml keys sites 2> /dev/null`
  echo ${value:-$@}
}

db_backups=`cat ${config} | shyaml get-value options.db_backups 2> /dev/null`

if [[ ${db_backups} != "False" ]]; then
  for domain in `get_sites`; do
    docker exec -it docker-mysql mysqldump -u root "${domain}" > "database/${domain}.sql"
    echo "backups initializing..."
    sleep 2
    echo ${domain}.sql has been backed up.
    echo ""
  done
fi
