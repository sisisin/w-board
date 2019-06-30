#!/usr/bin/env bash

set -ef -o pipefail

readonly script_dir=$(cd "$(dirname "$0")" && pwd)
readonly rev=$1
readonly rails_env=${2:-production}
export MYSQL_DATABASE=$3
export MYSQL_USER=$4
export MYSQL_PASSWORD=$5

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
export DB_IMAGE=sisisin/w-board-mysql:$rev
export RAILS_ENV=$rails_env
export DATABASE_URL="mysql2://$MYSQL_USER:$MYSQL_PASSWORD@db/$MYSQL_DATABASE"

function run_docker(){
    docker-compose pull
    
    # todo: specify kill target
    # app_container_id=$(docker ps | grep w-board:$rev | awk '{print $1}')
    [[ "$(docker ps -q)" != "" ]] && docker kill $(docker ps -q)

    docker-compose up -d && docker-compose run app bin/rails db:migrate
}

run_docker