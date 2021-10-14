#!/usr/bin/env bash

config="/srv/.global/custom.yml"

if [[ ! -f "${config}" ]]; then
    cp "/srv/config/default.yml" "/srv/.global/custom.yml"
fi