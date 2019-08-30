#!/bin/bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

if [[ ! -d "certificates/ca" ]]; then
    mkdir -p "certificates/ca"
    openssl genrsa -out "certificates/ca/ca.key" 4096 &> /dev/null
    openssl req -x509 -new -nodes -key "certificates/ca/ca.key" -sha256 -days 365 -out "certificates/ca/ca.crt" -subj "/CN=Sandbox Internal CA" &> /dev/null
fi

for domain in `get_sites`; do
    if [[ ! -d "certificates/${domain}" ]]; then
        mkdir -p "certificates/${domain}"
        cp "config/certs/domain.ext" "certificates/${domain}/${domain}.ext"
        sed -i -e "s/{{DOMAIN}}/${domain}/g" "certificates/${domain}/${domain}.ext"
        rm -rf "certificates/${domain}/${domain}.ext-e"

        openssl genrsa -out "certificates/${domain}/${domain}.key" 4096 &> /dev/null
        openssl req -new -key "certificates/${domain}/${domain}.key" -out "certificates/${domain}/${domain}.csr" -subj "/CN=*.${domain}.test" &> /dev/null
        openssl x509 -req -in "certificates/${domain}/${domain}.csr" -CA "certificates/ca/ca.crt" -CAkey "certificates/ca/ca.key" -CAcreateserial -out "certificates/${domain}/${domain}.crt" -days 365 -sha256 -extfile "certificates/${domain}/${domain}.ext" &> /dev/null
    fi
done