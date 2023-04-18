#!/usr/bin/env bash
set -eu
echo "First, let's init your organisation : "
read -p 'Organisation name: ' ORGANIZATION_NAME
echo "done ✅"
echo "Now, let's create your admin account : "
read -p 'Admin email 📧: ' ADMIN_EMAIL
read -p 'Admin password 🔒: ' ADMIN_PSW
echo "done ✅"
echo "Now, do you have a conduktor platform license : "
read -p 'Platform license [optional]: ' LICENSE_TOKEN
echo "done ✅"
echo "Conduktor platform is starting..."

export ORGANIZATION_NAME
export ADMIN_EMAIL
export ADMIN_PSW
export LICENSE_TOKEN

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

$SCRIPT_DIR/utils-local.sh start "$@"

start_status=`docker-compose ps 2> /dev/null |grep Exit| awk '{ print $1 }'`
if [[ x${start_status} != "x" ]]; then
    echo "${start_status} failed to start.  Check logs with 'docker-compose logs'"
fi
