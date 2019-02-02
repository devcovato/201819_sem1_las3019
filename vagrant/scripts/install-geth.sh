#!/usr/bin/env bash

{

set -e

if [[ $EUID -ne 0 ]]; then
  >&2 echo "[error] This script should be run using sudo or the root user"
  exit 1
fi

# go ethereum
if ! command -v geth > /dev/null; then
  echo "[info] Install Go Ethereum..."
  add-apt-repository -y ppa:ethereum/ethereum

  DEBIAN_FRONTEND=noninteractive \
    apt-get -qq update && \
    apt-get -qqy install gcc ethereum
else
  echo "[info] Go Ethreum already installed"
fi

}
