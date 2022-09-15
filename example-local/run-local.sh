#!/usr/bin/env bash
set -eu

read -p 'Organisation name: ' ORGANISATION_NAME
read -p 'Admin email: ' ADMIN_EMAIL
read -p 'Admin password: ' ADMIN_PSW


export ORGANISATION_NAME
export ADMIN_EMAIL
export ADMIN_PSW

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