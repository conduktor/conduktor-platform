#!/usr/bin/env bash
set -eu

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [[ "$#" == 0 ]]; then
    echo "provide a license key"
    exit 1
fi
$SCRIPT_DIR/utils-local.sh start "$@"

start_status=`docker-compose ps 2> /dev/null |grep Exit| awk '{ print $1 }'`
if [[ x${start_status} != "x" ]]; then
    echo "${start_status} failed to start.  Check logs with 'docker-compose logs'"
fi