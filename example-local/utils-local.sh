#!/usr/bin/env bash

set -eu

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
DOCKER_COMPOSE="docker compose" && [[ -x "$(command -v 'docker-compose')" ]] && DOCKER_COMPOSE="docker-compose"

start() {
  echo "ORGANIZATION_NAME : ${ORGANIZATION_NAME:? missing organization name}"
  echo "ADMIN_EMAIL : ${ADMIN_EMAIL:? missing admin email}"
  echo "ADMIN_PSW : ${ADMIN_PSW:? missing admin password}"
  echo "LICENSE_TOKEN : ${LICENSE_TOKEN:-}"

  $DOCKER_COMPOSE up -d
}

stop() {
  $DOCKER_COMPOSE down
}

rm() {
  $DOCKER_COMPOSE down -v 
}


# usage function
function _print_help()
{
   cat << HEREDOC
   Usage: $(basename $0) [command] <options>
   commands:
     help                   show this help message and exit
     start                  start platform
     stop                   stop platform
     rm                     rm platform datas
HEREDOC
}

main() {
  for i in "$@"; do
    case $i in
      -h|help)
        _print_help
        ;;
      start)
        shift
        start "$@"
        exit 0
        ;;
      stop)
        shift
        stop "$@"
        exit 0
        ;;
      rm)
        shift
        rm "$@"
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
