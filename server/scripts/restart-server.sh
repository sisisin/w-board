#!/usr/bin/env bash

set -ef -o pipefail

readonly script_dir=$(cd "$(dirname "$0")" && pwd)
readonly rev=$1
readonly rails_env=${2:-production}

function prepare_certs() {
    mkdir -p secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/cert.pem ./secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/chain.pem ./secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/fullchain.pem ./secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/privkey.pem ./secrets
}

prepare_certs

export APP_IMAGE=sisisin/w-board:$rev
export WEB_IMAGE=sisisin/w-board-nginx:$rev
export RAILS_ENV=$rails_env

docker-compose pull
[[ "$(docker ps -q)" != "" ]] && docker kill $(docker ps -q)
docker-compose up -d
