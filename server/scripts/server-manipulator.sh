#!/usr/bin/env bash

set -ef -o pipefail

readonly script_dir=$(cd "$(dirname "$0")" && pwd)
readonly command=$1

function prepare_certs() {
    mkdir -p secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/cert.pem ./secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/chain.pem ./secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/fullchain.pem ./secrets
    cp /etc/letsencrypt/live/api.w-board.sisisin.house/privkey.pem ./secrets
}

function run_docker() {
    source ./_env.sh

    docker-compose pull

    # todo: specify kill target
    # app_container_id=$(docker ps | grep w-board:$rev | awk '{print $1}')
    # [[ "$(docker ps -q)" != "" ]] && docker kill $(docker ps -q)

    docker-compose run --no-deps app bin/rails db:migrate
    docker-compose up --no-deps -d app
}

case "$command" in
deploy)
    prepare_certs
    run_docker
    ;;
*)
    echo "Unknown command: $command"
    exit 1
    ;;
esac
