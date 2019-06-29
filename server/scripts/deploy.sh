#!/usr/bin/env bash

set -ef -o pipefail

readonly script_dir=$(cd "$(dirname "$0")" && pwd)
cd "$script_dir"

function help(){
    cat <<EOF
Description:
  deployment scripts
Usage:
  deploy.sh [-h] COMMAND
Options:
  -h         show this help
Commands:
  deploy     deploy to prod
Examples:
  ./deploy.sh deploy
EOF
    exit 0
}

function run_rails_command(){
    cd "$script_dir/../"
    eval "$1"
    cd "$script_dir"
}

function build(){
    local _repository=$1
    local _revision=$2
    echo -e "Building: $_revision...\n"

    run_rails_command "bundle install"
    docker build -t $_repository:$_revision "$script_dir/../"
    docker build -t $_repository-nginx:$_revision "$script_dir/../docker/nginx"
}

function push(){
    local _repository=$1
    local _revision=$2
    docker login
    docker push $_repository:$_revision
    docker push $_repository-nginx:$_revision
}

function deploy(){
    local _revision=$1
    local _rails_env=$2
    scp "$script_dir/../docker-compose.yml" shizuku:/root/
    ssh shizuku 'bash -s' "$_revision" "$_rails_env"  <"$script_dir/restart-server.sh"
}

readonly revision=$(git rev-parse --short=10 HEAD)
readonly image_repository="sisisin/w-board"
readonly command=$1
[[ "$RAILS_ENV" = "" ]] && export RAILS_ENV=production

case "$command" in
    deploy)
        build "$image_repository" "$revision"
        push "$image_repository" "$revision"
        deploy "$revision" "$RAILS_ENV"
        ;;
    restart)
        deploy "$revision" "$RAILS_ENV"
        ;;
    build)
        build "$image_repository" "$revision"
        ;;
    push)
        push "$image_repository" "$revision"
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac
