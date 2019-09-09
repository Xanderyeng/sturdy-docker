#!/bin/bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "templates/docker-setup.yml" "config/docker-custom.yml"
    cp "templates/docker-compose.yml" "docker-compose.yml"
fi