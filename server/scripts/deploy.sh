#!/usr/bin/env bash

set -ef -o pipefail

readonly script_dir=$(cd "$(dirname "$0")" && pwd)
cd "$script_dir"

function help() {
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

function run_rails_command() {
    cd "$script_dir/../"
    eval "$1"
    cd "$script_dir"
}

function build() {
    local _repository=$1
    local _revision=$2
    echo -e "Building: $_revision...\n"

    run_rails_command "bundle install"
    docker build -t $_repository:$_revision "$script_dir/../"
    docker build -t $_repository-nginx:$_revision "$script_dir/../docker/nginx"
    docker build -t $_repository-mysql:$_revision "$script_dir/../docker/mysql"
}

function push() {
    local _repository=$1
    local _revision=$2
    docker login
    docker push $_repository:$_revision
    docker push $_repository-nginx:$_revision
    docker push $_repository-mysql:$_revision
}

function exit_if_undefined_env_vars() {
    [[ -z "${MYSQL_DATABASE+UNDEF}" ]] && echo "MYSQL_DATABASE must be set" && exit 1
    [[ -z "${MYSQL_USER+UNDEF}" ]] && echo "MYSQL_USER must be set" && exit 1
    [[ -z "${MYSQL_PASSWORD+UNDEF}" ]] && echo "MYSQL_PASSWORD must be set" && exit 1
    return 0
}

function create_env_file() {
    local _repository=$1
    local _revision=$2
    cat <<EOF >"$script_dir/_env.sh"
# for specify image with tag
export APP_IMAGE=$_repository:$_revision
export WEB_IMAGE=$_repository-nginx:$_revision
export DB_IMAGE=$_repository-mysql:$_revision

# for db
export MYSQL_DATABASE=$MYSQL_DATABASE
export MYSQL_USER=$MYSQL_USER
export MYSQL_PASSWORD=$MYSQL_PASSWORD

# for app
export RAILS_ENV=$RAILS_ENV
export DATABASE_URL="mysql2://$MYSQL_USER:$MYSQL_PASSWORD@db/$MYSQL_DATABASE"
EOF
}

function run_server_command() {
    local _cmd=$1
    ssh shizuku 'bash -s' "$_cmd" <"$script_dir/server-manipulator.sh"
}

function deploy_files() {
    exit_if_undefined_env_vars

    local _repository=$1
    local _revision=$2

    echo "Start deployment files"
    create_env_file "$image_repository" "$revision"
    run_server_command "prepare_logs"

    scp "$script_dir/_env.sh" shizuku:/root/
    scp "$script_dir/run-import.sh" shizuku:/root/
    scp "$script_dir/server-manipulator.sh" shizuku:/root/
    scp "$script_dir/app_cron" shizuku:/etc/cron.d
    scp "$script_dir/../docker-compose.yml" shizuku:/root/
}

function deploy() {
    echo "Start deployment"
    run_server_command "deploy"
}

readonly revision=$(git rev-parse --short=10 HEAD)
readonly image_repository="sisisin/w-board"
readonly command=$1
[[ "$RAILS_ENV" == "" ]] && export RAILS_ENV=production

case "$command" in
deploy)
    build "$image_repository" "$revision"
    push "$image_repository" "$revision"
    deploy_files "$image_repository" "$revision"
    deploy
    ;;
deploy_files)
    deploy_files "$image_repository" "$revision"
    ;;
restart)
    deploy "$image_repository" "$revision"
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
