#!/usr/bin/env bash
# (C) Conduktor, Inc. 2022-present
# All rights reserved
# Conduktor Platform installation script using docker-compose
#
# For any request, please contact us: support@conduktor.io
# Looking for a job? Say hi: https://www.conduktor.io/careers
#

set -eu

DOCKER_COMPOSE="docker compose" && [[ -x "$(command -v 'docker-compose')" ]] && DOCKER_COMPOSE="docker-compose"
CACHE_DIR=$(mktemp -d)
BINARY_DIR="${CACHE_DIR}/.bin"
CONFIG_FILE="${CACHE_DIR}/config.yaml"
GIT_BRANCH=${GIT_BRANCH:-"main"}
GIT_SOURCE=${GIT_SOURCE:-"https://raw.githubusercontent.com/conduktor/conduktor-platform"}
CURL_PATH="${GIT_SOURCE}/${GIT_BRANCH}"
PATH="${BINARY_DIR}:${PATH}"

SUPPORT_EMAIL="support@conduktor.io"
CRASH_LOG_FILE="conduktor-platform.log"

COMPOSE_MIN_VERSION="1.12.0"

# Force input of variables
FORCE_CONFIG=${FORCE_CONFIG:-"false"}
# This array of images is needed in order to prune and save
# some disk usage when shutting down platform. This behavior
# can be cancelled by injecting NO_PRUNE=true
COMPOSE_IMAGES="conduktor/conduktor-platform conduktor/kafka:3.3.1"
NO_PRUNE=${NO_PRUNE:-"true"}

# Platform variables
LICENSE_TOKEN=${LICENSE_TOKEN:-}
ORGANIZATION_NAME=${ORGANIZATION_NAME:-}
ADMIN_EMAIL=${ADMIN_EMAIL:-}
ADMIN_PSW=${ADMIN_PSW:-}

###
# Rewrite commands to prevent useless logs
###
function pushd() {
    command pushd "$@" > /dev/null
}

function popd() {
    command popd "$@" > /dev/null
}

function download() {
    local target_file=$1
    local url=$2
    echo "Downloading file from ${url}"

    curl -s -o "$target_file" "$url"
}

function downloadFiles() {
    # When you want to develop around this script and use local files, uncomment below lines
    # cp ../docker-compose.yml ${CACHE_DIR}/
    # cp ../jmx-exporter.yml ${CACHE_DIR}/
    # cp ../platform-config.yaml ${CACHE_DIR}/
    download "${CACHE_DIR}/docker-compose.yml" "${CURL_PATH}/example-local/docker-compose.yml"
    download "${CACHE_DIR}/jmx-exporter.yml" "${CURL_PATH}/example-local/jmx-exporter.yml"
    download "${CACHE_DIR}/platform-config-no-license.yaml" "${CURL_PATH}/example-local/platform-config-no-license.yaml"
    download "${CACHE_DIR}/platform-config.yaml" "${CURL_PATH}/example-local/platform-config.yaml"
    
    # Binary dependencies
    mkdir ${BINARY_DIR}
    download "${BINARY_DIR}/semver" "https://raw.githubusercontent.com/fsaintjacques/semver-tool/3.3.0/src/semver"

    chmod +x "${BINARY_DIR}/semver"
}

function notEmptyOrInput() {
    local var_name=${1:-}
    local description=${2:-"Your input: "}
    local optional=${3:-false}
    local input=""
    if [ -z "${!var_name}" ]; then
        if [ "$optional" == "false" ]; then
          while read -p "${description}" input && [ -z "$input" ]; do :; done
        else 
          read -p "${description}" input
        fi
        export ${var_name}=${input}
        trap "unset ${var_name}" EXIT
    fi
}

info() {
  printf "\033[34m\n* %s\n\033[0m\n" "${@}"
}

err() {
  printf "\033[33m\n* %s\n\033[0m\n" "${@}"
}

function support_msg() {
  printf "
If you are still having problems, please check https://github.com/conduktor/conduktor-platform
and if your issue persists, please send an email to %s
with the contents of %s and any information you think would be
useful and we will do our very best to help you solve your problem.\n\n" "${SUPPORT_EMAIL}" "${CRASH_LOG_FILE}"
}


function trapStop() {
    if [[ ${DOCKER_EXIT_CODE:-0} == 130 ]]; then
        info "Conduktor Platform stopped by CTRL+C"
    elif [[ ${DOCKER_EXIT_CODE:-0} != 0 ]]; then
        err "Conduktor Platform failed to start. Please check the logs in $CRASH_LOG_FILE. Here are the last 10 lines:"
        ${DOCKER_COMPOSE} -f "${CACHE_DIR}/docker-compose.yml" logs conduktor-platform > "$CRASH_LOG_FILE" 2>&1 
        tail -n 10 "$CRASH_LOG_FILE"
        support_msg
    fi
    pushd "${CACHE_DIR}"
    ${DOCKER_COMPOSE} down -v > /dev/null
    popd
    
    prune
}

function prune() {
    if [ "${NO_PRUNE}" == "true" ]; then
      return
    fi

    info "Cleaning up docker images (use NO_PRUNE=true to prevent this)"
    for image in ${COMPOSE_IMAGES}; do
      printf "Pruning docker image %s..." "${image}"
      docker image rm -f "${image}" > /dev/null && echo " OK" || echo "KO. Error pruning, skipping..."
    done
}

verify_installed()
{
  local cmd="$1"
  if [[ $(type "$cmd" 2>&1) =~ "not found" ]]; then
    err "This script requires '$cmd'. Please install '$cmd' and run again."
    exit 1
  fi
  return 0
}

check_docker_compose_version() {
  local version=$(${DOCKER_COMPOSE} version --short)

  # Semver is a tool used to compare two versions following semantic
  # versioning. Returns 1 if ${version} is above ${COMPOSE_MIN_VERSION},
  # 0 when equal and -1 when inferior. We use docker-compose arguments
  # that were added in $COMPOSE_MIN_VERSION, that's the reason of this
  # piece of code.
  local compare=$(semver compare "${version}" "${COMPOSE_MIN_VERSION}")
  if [ "${compare}" == "1" ] || [ "${compare}" == "0" ]; then
    return 0 
  else 
    err "It seems that you are running an unsupported version of docker-compose (<${COMPOSE_MIN_VERSION}), found version: ${version}.
You can upgrade it from docker website: https://docs.docker.com/compose/install/"
    support_msg
    exit 1
  fi
}

function setup() {
    verify_installed curl

    local _file="${CACHE_DIR}/conduktor-platform.sh"
    download "$_file" "${CURL_PATH}/example-local/autorun/autorun.sh"
    chmod u+x "$_file"
    # The installer is going to want to ask for confirmation by
    # reading stdin.  This script was piped into `sh` though and
    # doesn't have stdin to pass to its children. Instead we're going
    # to explicitly connect /dev/tty to the installer's stdin.
    "$_file" "run" "$@" < /dev/tty
}

function run() {
    verify_installed curl
    verify_installed docker
    verify_installed ${DOCKER_COMPOSE}

    local composeOpts=""

    info "Welcome to Conduktor Platform installation script!
* Go to https://github.com/conduktor/conduktor-platform if you need any help

* Launching Conduktor Platform on your machine..."

    mkdir -p "${CACHE_DIR}" || err "Something went wrong, do you have access to create folder in ${CACHE_DIR} ?" || exit 1
    downloadFiles || err "Failed to download files, is GitHub online ?" || exit 1

    check_docker_compose_version

    info "To provide you with the best possible user experience, we need some information:"
    notEmptyOrInput ORGANIZATION_NAME "Organisation name: "
    notEmptyOrInput ADMIN_EMAIL "Admin email 📧: "
    notEmptyOrInput ADMIN_PSW "Admin password 🔒: "
    notEmptyOrInput LICENSE_TOKEN "License key [OPTIONAL]: " true

    pushd ${CACHE_DIR}
    info "Pulling Conduktor Platform docker images..."
    ${DOCKER_COMPOSE} ${composeOpts} pull

    info "Starting Conduktor Platform (press CTRL+C to stop)"
    echo "--> Go to http://localhost:8080 <--"
    echo

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
        exit 0
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
  _print_help
}


main "$@"
