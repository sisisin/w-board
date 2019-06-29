#!/usr/bin/env bash

readonly rev=$1
readonly rails_env=$2

docker kill $(docker ps -q)
docker run \
    -idt \
    -p 80:3000 \
    -v /etc/letsencrypt/live/api.w-board.sisisin.house:/usr/src/w-board/certs \
    -e RAILS_ENV="$rails_env" \
    sisisin/w-board:$rev
