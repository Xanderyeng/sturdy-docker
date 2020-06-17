#!/bin/bash
config="$PWD/.global/custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    if ! grep -q "dashboard.test" /mnt/c/Windows/System32/drivers/etc/hosts; then
        wp4docker-hosts set 127.0.0.1 dashboard.test
    fi
else
    if ! grep -q "dashboard.test" /etc/hosts; then
        sudo wp4docker-hosts set 127.0.0.1 dashboard.test
    fi
fi

for domain in `get_sites`; do
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        wp4docker-hosts set 127.0.0.1 ${domain}.test
  else
        sudo wp4docker-hosts set 127.0.0.1 ${domain}.test
  fi
done
