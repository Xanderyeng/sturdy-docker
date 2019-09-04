#!/bin/bash

if [[ ! -f "config/docker-custom.yml" ]]; then
    cp "config/docker-setup.yml" "config/docker-custom.yml"
    cp "config/docker-compose-setup.yml" "docker-compose.yml"
fi