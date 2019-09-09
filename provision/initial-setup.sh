#!/bin/bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "config/docker-setup.yml" "config/docker-custom.yml"
    cp "templates/docker-compose.tmpl" "docker-compose.yml"
fi