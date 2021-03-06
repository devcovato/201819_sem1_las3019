#!/usr/bin/env bash

# Provisioning Ethereum development environment

{

set -e

if [[ $EUID -ne 0 ]]; then
  >&2 echo "[error] This script should be run using sudo or the root user"
  exit 1
fi

cd_path=$(cd `dirname $0`; pwd)

DEBIAN_FRONTEND=noninteractive \
  apt-get -qq  update && \
  apt-get -qqy install unzip

bash "$cd_path/install-geth.sh"

bash "$cd_path/install-chromedriver.sh"

bash "$cd_path/install-phantomjs.sh"

}
