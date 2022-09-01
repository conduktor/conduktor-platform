#!/usr/bin/env bash
set -eu

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

$SCRIPT_DIR/utils-local.sh rm
