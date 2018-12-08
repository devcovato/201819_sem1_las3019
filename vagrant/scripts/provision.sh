#!/usr/bin/env bash

# Provisioning Ethereum development environment

{

set -e

if [[ $EUID -ne 0 ]]; then
  >&2 echo "[error] This script should be run using sudo or the root user"
  exit 1
fi

cd_path=$(cd `dirname $0`; pwd)

bash "$cd_path/install-geth.sh"

}
