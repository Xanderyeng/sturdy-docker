#!/usr/bin/env bash

if [[ ! -f ".global/docker-custom.yml" ]]; then
    cp "config/templates/docker-setup.yml" ".global/docker-custom.yml"
fi
