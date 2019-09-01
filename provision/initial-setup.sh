
#!/bin/bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "config/docker-setup.yml" "config/docker-custom.yml"
fi

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do

    if [[ ! -f "config/nginx/${domain}" ]]; then
        cp "config/nginx/nginx.tmpl" "config/nginx/${domain}.conf"
        if grep -q "{{DOMAIN}}" "config/nginx/${domain}.conf"; then
            sed -i -e "s/{{DOMAIN}}/${domain}/g" "config/nginx/${domain}.conf"
            rm -rf "config/nginx/${domain}.conf-e"
        fi
    fi

    get_hosts() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.host`
        echo ${value:$@}
    }

    get_address() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.address`
        echo ${value:$@}
    }

    for host in `get_hosts`; do 
        if grep -q "{{HOST}}" "config/nginx/${domain}.conf"; then
            sed -i -e "s/{{HOST}}/${host}/g" "config/nginx/${domain}.conf"
            rm -rf "config/nginx/${domain}.conf-e"
        fi
    done

    for address in `get_address`; do
        if grep -q "{{IP_ADDRESS}}" "config/nginx/${domain}.conf"; then
            sed -i -e "s/{{IP_ADDRESS}}/${address}/g" "config/nginx/${domain}.conf"
            rm -rf "config/nginx/${domain}.conf-e"
        fi
    done
done
