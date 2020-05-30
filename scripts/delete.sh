#!/usr/bin/env bash

home=$PWD
config="${home}/.global/docker-custom.yml"


get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

cd sites
for domain in $( ls ); do
    if ! grep -q ${domain} ${config}; then
        if [[ "dashboard" != ${domain} ]]; then 
            rm -rf ${domain}
            rm -rf ../certificates/${domain}
            rm -rf ../config/nginx/${domain}.conf

            if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
                if grep -q "${domain}.test" /mnt/c/Windows/System32/drivers/etc/hosts; then
                    sed -i "/${domain}.test/d" /mnt/c/Windows/System32/drivers/etc/hosts
                fi
            else
                if grep -q "${domain}.test" /etc/hosts; then
                    sed -i "/${domain}.test/d" /etc/hosts
                fi
            fi
        fi
    fi

done