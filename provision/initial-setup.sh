
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

    for host in `get_hosts`; do 
        if grep -q "{{HOST}}" "config/nginx/${domain}.conf"; then
            sed -i -e "s/{{HOST}}/${host}/g" "config/nginx/${domain}.conf"
            rm -rf "config/nginx/${domain}.conf-e"
        fi

        if ! grep -q "${host}" /etc/hosts; then
           echo "127.0.0.1     ${domain}.test" | sudo tee -a /etc/hosts
        else
            echo "${host} already exists in /etc/hosts"
        fi
    done
done
