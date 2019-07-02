#!/usr/bin/env bash

set -ef -o pipefail

readonly work_dir=/root
readonly command=$1


function log_info(){
    echo "[$(date '+%F %T')] $1"
}

function prepare_log_dirs() {
    mkdir -p "$work_dir/logs/cron/"
}

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

function run_import(){
    source ./_env.sh
    log_info "cron test $APP_IMAGE"
}

cd "$work_dir"
case "$command" in
deploy)
    prepare_certs
    run_docker
    ;;
prepare_logs)
    prepare_log_dirs
    ;;
run_import)
    run_import
    ;;
*)
    echo "Unknown command: $command"
    exit 1
    ;;
esac