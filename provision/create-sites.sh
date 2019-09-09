#!/bin/bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    provision=`cat ${config} | shyaml get-value sites.${domain}.provision`

    if [[ "True" == ${provision} ]]; then
        if [[ ! -f "config/nginx/${domain}.conf" ]]; then
            cp "templates/nginx.conf" "config/nginx/${domain}.conf"

            if grep -q "{{DOMAIN}}" "config/nginx/${domain}.conf"; then
                sed -i -e "s/{{DOMAIN}}/${domain}/g" "config/nginx/${domain}.conf"
                rm -rf "config/nginx/${domain}.conf-e"
            fi
            mkdir -p "sites/${domain}"
        fi

        get_hosts() {
            local value=`cat ${config} | shyaml get-value sites.${domain}.host`
            echo ${value:$@}
        }

        for host in `get_hosts`; do 
            if grep -q "{{HOST}}" "config/nginx/${domain}.conf"; then
                sed -i -e "s/{{HOST}}/${host}/g" "config/nginx/${domain}.conf"
                rm -rf "config/nginx/${domain}.conf-e"
            fi

            if ! grep -q "${host}" /etc/hosts; then
            echo "127.0.0.1     ${domain}.test" | sudo tee -a /etc/hosts
            fi
        done
    fi
done