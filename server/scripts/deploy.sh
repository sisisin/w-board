#!/usr/bin/env bash

set -ef -o pipefail

readonly work_dir=$(cd "$(dirname "$0")" && pwd)

ssh shizuku 'bash -s' $(git rev-parse --short=10 HEAD) <"$work_dir/restart-server.sh"
