#!/usr/bin/env bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "config/templates/docker-setup.yml" "config/docker-custom.yml"
fi
