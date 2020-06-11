#!/bin/bash
config="/srv/.global/custom.yml"
compose="$PWD/.global/docker-compose.yml"

get_sites() {
  local value=`cat ${config} | shyaml keys sites 2> /dev/null`
  echo ${value:-$@}
}

domains=`get_sites`

db_backups=`cat ${config} | shyaml get-value options.db_backups 2> /dev/null`

if [[ ${db_backups} != "False" ]]; then
	for domain in ${domains//- /$'\n'}; do
    mysqldump -u root -e "${domain}" > "/srv/databases/${domain}.sql"
	done
fi
