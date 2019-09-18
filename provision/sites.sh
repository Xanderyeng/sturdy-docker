#!/bin/bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do
    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`

    if [[ "True" == ${provision} ]]; then
        repo="https://github.com/benlumia007/docker-for-wordpress-sites.git"
        dir="sites/${domain}"

        if [[ false != "${repo}" ]]; then
            if [[ ! -d "${dir}/provision/.git" ]]; then
                git clone ${repo} ${dir}/provision -q
            else
                cd "${dir}/provision"
                git pull origin master -q
                cd ../../..
            fi
        fi

        if [[ -d ${dir} ]]; then
            if [[ -f ${dir}/provision/setup.sh ]]; then
                source ${dir}/provision/setup.sh
            fi
        fi
    else
        rm -rf "certificates/${domain}.crt"
        rm -rf "certificates/${domain}.key"
        rm -rf "certificates/${domain}.csr"
        rm -rf "certificates/${domain}.ext"
        rm -rf "config/nginx/${domain}.conf"

        if grep -q "${domain}.test" /etc/hosts; then
            uname=`uname`
            if [[ ${uname} == "Linux" ]]; then
                sudo sed -i "/${domain}.test/d" "/etc/hosts"
            else
                sudo sed -i '' "/${domain}.test/d" "/etc/hosts"
            fi
        fi

        docker exec -it docker-mysql mysql -u root -e "DROP DATABASE IF EXISTS ${domain};"
        docker exec -it docker-mysql mysql -u root -e "REVOKE ALL PRIVILEGES ON ${domain}.* FROM 'wordpress'@'%';"
        docker exec -it docker-mysql mysql -u root -e "FLUSH PRIVILEGES;"
        rm -rf "sites/${domain}"
    fi
done
