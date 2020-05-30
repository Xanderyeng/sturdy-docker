#!/usr/bin/env bash

config=".global/docker-custom.yml"

get_sites() {
  local value=`cat ${config} | shyaml get-value sites.domain 2> /dev/null`
  echo ${value:-$@}
}

db_backups=`cat ${config} | shyaml get-value options.db_backups 2> /dev/null`

domains=`get_sites`

if [[ ${db_backups} != "False" ]]; then
	for domain in ${domains//- /$'\n'}; do
		docker exec -i docker-mysql mysqldump -u root "${domain}" > "database/${domain}.sql"
	done
fi