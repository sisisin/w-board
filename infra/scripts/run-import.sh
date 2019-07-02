#!/usr/bin/env bash

set -ef -o pipefail
work_dir=/root

source "$work_dir/.bashrc"

"$work_dir/server-manipulator.sh" run_import
