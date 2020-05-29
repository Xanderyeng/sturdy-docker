#!/usr/bin/env bash

config=".global/docker-custom.yml"

if [[ ! -f ".global/docker-custom.yml" ]]; then
    cp "config/templates/docker-compose.yml" ".global/docker-compose.yml"
    cp "config/templates/docker-setup.yml" ".global/docker-custom.yml"
fi