#!/usr/bin/env bash

set -eu

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
DOCKER_COMPOSE="docker compose" && [[ -x "$(command -v 'docker-compose')" ]] && DOCKER_COMPOSE="docker-compose"

start() {
  export LICENSE_KEY="${1:-}"

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
