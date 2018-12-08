#!/usr/bin/env bash

# Setup Ethereum Development Environment
{

set -e

cd_path=$(cd `dirname $0`; pwd)

# nvm
(
  exec "$BASH" -il "$cd_path/install-nvm.sh"
)
# node
(
  exec "$BASH" -il "$cd_path/install-node-nvm.sh"
)
# truffle
(
  exec "$BASH" -il "$cd_path/install-truffle.sh"
)

}
