#!/usr/bin/env bash
set -eu

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [[ "$#" == 0 ]]; then
    echo "provide a license key"
    exit 1
fi
$SCRIPT_DIR/utils-local.sh start "$@"
