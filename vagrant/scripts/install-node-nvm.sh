#!/usr/bin/env bash

# Install node
{

set -e

if [[ $EUID -eq 0 ]]; then
  >&2 echo "[error] This script should not be run using sudo or the root user"
  exit 1
fi

# nodejs
DEFAULT_NODE_VER='10.14.1'
NODE_VER="${INSTALL_NODE_VERSION:-$DEFAULT_NODE_VER}"

# install node
if [[ $(nvm ls $NODE_VER | grep -c 'N/A') -eq 1 ]]; then
  nvm install $NODE_VER > /dev/null 2>&1
  node -v
else
  echo "[info] node $NODE_VER is already installed"
fi
nvm alias default $NODE_VER
echo "[info] npm ($(npm -v)) is installed"

}
