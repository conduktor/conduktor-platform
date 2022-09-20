#!/usr/bin/env bash
set -eu

DOCKER_COMPOSE="docker compose" && [[ -x "$(command -v 'docker-compose')" ]] && DOCKER_COMPOSE="docker-compose"
CACHE_DIR="$HOME/.cache/conduktor-platform"
CONFIG_FILE="${CACHE_DIR}/config.yaml"

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
    curl -s -o ${CACHE_DIR}/docker-compose.yml https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/docker-compose.yml
    curl -s -o ${CACHE_DIR}/jmx-exporter.yml https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/jmx-export.yml
    curl -s -o ${CACHE_DIR}/platform-config.yaml https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/platform-config.yaml
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

function clean() {
    echo "-> We are currently cleaning the few files we created..."
    pushd ${CACHE_DIR}
    ${DOCKER_COMPOSE} down -v 
    popd
    rm -rf ${CACHE_DIR}
}

function run() {
    echo "-> Launching Conduktor Platform on your machine..."
    if [ ! -d "${CACHE_DIR}" ]; then
        echo "-> Downloading files..."
        mkdir -p  ${CACHE_DIR} || echo "Something went wrong, do you have access to create folder in ${CACHE_DIR} ?" || exit 1
        downloadFiles || echo "Failed to download files, is GitHub online ?" || exit 1
    fi

    notEmptyOrInput LICENSE_KEY "Your license key: "
    notEmptyOrInput ORGANISATION_NAME "Organisation name: "
    notEmptyOrInput ADMIN_EMAIL "Admin email 📧: "
    notEmptyOrInput ADMIN_PSW "Admin password 🔒: "
    
    pushd ${CACHE_DIR}
    echo "-> In a few seconds, Conduktor Platform should be ready on http://localhost:8080"
    echo "-> Press CTRL+C at anytime to stop the platform"
    ${DOCKER_COMPOSE} --log-level ERROR up -V \
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
     clean                  rm platform datas
HEREDOC
}

main() {
  for i in "$@"; do
    case $i in
      -h|help)
        _print_help
        ;;
      run)
        shift
        run "$@"
        exit 0
        ;;
      clean)
        shift
        clean "$@"
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
