#!/bin/sh
set -eu

DOCKER_COMPOSE="docker compose" && [[ -x "$(command -v 'docker-compose')" ]] && DOCKER_COMPOSE="docker-compose"
CACHE_DIR=$(mktemp -d)
CONFIG_FILE="${CACHE_DIR}/config.yaml"
GIT_BRANCH=${GIT_BRANCH:-"main"}
GIT_SOURCE=${GIT_SOURCE:-"https://raw.githubusercontent.com/conduktor/conduktor-platform"}
CURL_PATH="${GIT_SOURCE}/${GIT_BRANCH}"

# Force input of variables
FORCE_CONFIG=${FORCE_CONFIG:-"false"}

# Platform variables
LICENSE_KEY=${LICENSE_KEY:-}
ORGANISATION_NAME=${ORGANISATION_NAME:-"Some organisation"}
ADMIN_EMAIL=${ADMIN_EMAIL:-"admin@admin.com"}
ADMIN_PSW=${ADMIN_PSW:-"admin"}

###
# Rewrite commands to prevent useless logs
###
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

function downloadFiles() {
    # When you want to develop around this script and use local files, uncomment below lines
    # cp ../docker-compose.yml ${CACHE_DIR}/
    # cp ../jmx-exporter.yml ${CACHE_DIR}/
    # cp ../platform-config.yaml ${CACHE_DIR}/
    # cp ../platform-config-no-license.yaml ${CACHE_DIR}/
    curl -s -o ${CACHE_DIR}/docker-compose.yml ${CURL_PATH}/example-local/docker-compose.yml
    curl -s -o ${CACHE_DIR}/jmx-exporter.yml ${CURL_PATH}/example-local/jmx-exporter.yml
    curl -s -o ${CACHE_DIR}/platform-config.yaml ${CURL_PATH}/example-local/platform-config.yaml
    curl -s -o ${CACHE_DIR}/platform-config-no-license.yaml ${CURL_PATH}/example-local/platform-config-no-license.yaml
}

function notEmptyOrInput() {
    local var_name=${1:-}
    local description=${2:-"Your input: "}
    local input=""
    if [ -z "${!var_name}" ]; then 
        echo "-> Please enter value for variable ${var_name}"
        read -p "${description}" input
        export ${var_name}=${input}
        trap "unset ${var_name}" EXIT
    fi
}

function trapStop() {
    if [[ ${DOCKER_EXIT_CODE:-0} != 0 ]]; then
        echo "-> Platform failed to run, please verify your license key"
        echo "A dump of platform logs is available in file crash.log"
        docker-compose -f ${CACHE_DIR}/docker-compose.yml logs conduktor-platform > crash.log
    fi
    pushd ${CACHE_DIR}
    ${DOCKER_COMPOSE} down -v > /dev/null
    popd
}


function setup() {
    local _file="${CACHE_DIR}/conduktor-platform.sh"
    curl -s -o $_file ${CURL_PATH}/example-local/autorun/autorun.sh
    chmod u+x $_file
    # The installer is going to want to ask for confirmation by
    # reading stdin.  This script was piped into `sh` though and
    # doesn't have stdin to pass to its children. Instead we're going
    # to explicitly connect /dev/tty to the installer's stdin.
    "$_file" "run" "$@" < /dev/tty
}

function run() {
    local composeOpts="--log-level ERROR"

    echo "-> Launching Conduktor Platform on your machine..."
    echo "-> Downloading files..."
    mkdir -p  ${CACHE_DIR} || echo "Something went wrong, do you have access to create folder in ${CACHE_DIR} ?" || exit 1
    downloadFiles || echo "Failed to download files, is GitHub online ?" || exit 1

    notEmptyOrInput LICENSE_KEY "License key [OPTIONAL]: "

    if [ -z "${LICENSE_KEY}" ]; then
        export CONF_NAME=platform-config-no-license
        sed -i '' "s/^.*LICENSE_KEY.*$//g" ${CACHE_DIR}/docker-compose.yml
    else 
      export CONF_NAME=platform-config
      echo "LICENSE_KEY=${LICENSE_KEY}" > ${CACHE_DIR}/.env
      composeOpts="${composeOpts} --env-file ${CACHE_DIR}/.env"
    fi
    
    notEmptyOrInput ORGANISATION_NAME "Organisation name: "
    notEmptyOrInput ADMIN_EMAIL "Admin email 📧: "
    notEmptyOrInput ADMIN_PSW "Admin password 🔒: "
    
    pushd ${CACHE_DIR}
    echo "-> In a few seconds, Conduktor Platform should be ready on http://localhost:8080"
    echo "-> Press CTRL+C at anytime to stop the platform"
    ${DOCKER_COMPOSE} ${composeOpts} up -V \
        --abort-on-container-exit --exit-code-from conduktor-platform > /dev/null \
        || export DOCKER_EXIT_CODE="$?"
    popd

    trap "trapStop" SIGINT SIGTERM SIGQUIT EXIT
}

# usage function
function _print_help()
{
   cat << HEREDOC
   Usage: $(basename $0) [command] <options>
   commands:
     help                   show this help message and exit
     run                    start platform
     setup                  force start to be in interactive mode
     clean                  rm platform datas
HEREDOC
}

main() {
  for i in "$@"; do
    case $i in
      -h|help)
        _print_help
        ;;
      setup)
        shift
        setup "$@"
        exit 0
        ;;
      run)
        shift
        run "$@"
        exit 0
        ;;
      *)
        echo "Command not found"
        _print_help
        exit 1
        ;;
    esac
  done
}


main "$@"