#!/bin/bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    provision=`cat ${config} | shyaml get-value sites.${domain}.provision`

    if [[ "False" == ${provision} ]]; then
        rm -rf "certificates/${domain}.crt"
        rm -rf "certificates/${domain}.key"
        rm -rf "config/nginx/${domain}.conf"

        get_hosts() {
            local value=`cat ${config} | shyaml get-value sites.${domain}.host`
            echo ${value:$@}
        }

        for host in `get_hosts`; do 
            if grep -q "${host}" /etc/hosts; then
                sudo sed -i '' "/${host}/d" "/etc/hosts"
            fi
        done
        docker exec -it docker-mysql mysql -u root -e "DROP DATABASE IF EXISTS ${domain};"
        docker exec -it docker-mysql mysql -u root -e "REVOKE ALL PRIVILEGES ON ${domain}.* FROM 'wordpress'@'%';"
        docker exec -it docker-mysql mysql -u root -e "FLUSH PRIVILEGES;"
        rm -rf "sites/${domain}"
    fi    
done