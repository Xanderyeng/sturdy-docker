#!/usr/bin/env bash

config=$PWD/.global/custom.yml

if [[ ! -f "${config}" ]]; then
  cp "/app/config/templates/default.yml" "/srv/.global/custom.yml"
fi
