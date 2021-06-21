#!/usr/bin/env bash

# noroot
#
# noroot allows provision scripts to be run as the default user "www-data" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "www-data" "$@";
}


config="/srv/.global/custom.yml"

if [[ ! -f "${config}" ]]; then
  noroot cp "/srv/config/default.yml" "/srv/.global/custom.yml"
fi