#!/usr/bin/env bash

PROXY_ARGS="--env http_proxy=${http_proxy} \
            --env no_proxy=${no_proxy}"

docker pull docker/compose:1.18.0

function docker-compose() {
    docker run ${PROXY_ARGS} -v "$(pwd)":"$(pwd)" -v /var/run/docker.sock:/var/run/docker.sock -e COMPOSE_PROJECT_NAME=$(basename "$(pwd)") -ti --rm --workdir="$(pwd)" dduportal/docker-compose:latest $@
}

CURRENT_DIR=$(pwd)

if [ ! -d ${CURRENT_DIR}/tmp ]; then
    mkdir -p tmp
fi

export PUID=$(id -u)
export PGID=$(id -g)

docker-compose $@
