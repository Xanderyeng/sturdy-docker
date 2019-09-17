#!/usr/bin/env bash

running=`docker inspect -f '{{.State.Running}}' docker-nginx 2> /dev/null`

if [[ "${running}" = "true" ]]; then
    echo "server started..."
else
    echo "starting server..."
    docker-compose up -d
fi
