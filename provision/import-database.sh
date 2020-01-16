#!/usr/bin/env bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

db_restores=`cat ${config} | shyaml get-value options.db_restores 2> /dev/null`

if [[ "${db_restores}" == "False" ]]; then
    exit;
fi

for database in `get_sites`; do
	running=`docker inspect -f '{{.State.Running}}' docker-mysql 2> /dev/null`

	if [[ ${running} == "true" ]]; then
		docker exec -it docker-mysql mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${database};"
		docker exec -it docker-mysql mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'wordpress';"
		docker exec -it docker-mysql mysql -u root -e "GRANT ALL PRIVILEGES ON ${database}.* to 'wordpress'@'%' WITH GRANT OPTION;"
		docker exec -it docker-mysql mysql -u root -e "FLUSH PRIVILEGES;"
	fi
done

# count
#
# ahh, so this is interesting one, count will find all of the *.sql and show how many, for example
# if there is 3 files then it will list 3, this allows us to do the next part.
cd database
count=`ls -1 *.sql 2>/dev/null | wc -l`

# $count != 0
#
# apparently, when you vagrant halt or vagrant destroy, it will then back up the database and will
# use mysqldump to generate a *.sql. so if you have 1 or more sites then it will start importing
# database.
if [[ $count != 0 ]]; then
    for file in $( ls *.sql ); do
      domain=${file%%.sql}

	  running=`docker inspect -f '{{.State.Running}}' docker-mysql 2> /dev/null`

	  if [[ ${running} == "true" ]]; then
		exists=`docker exec -it docker-mysql mysql -u root --skip-column-names -e "SHOW TABLES FROM ${domain};"`

		if  [[ "" == ${exists} ]]; then
			docker exec -i docker-mysql mysql -u root ${domain} < ${domain}.sql
		fi
	  fi
    done
fi
