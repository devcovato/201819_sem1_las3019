#!/usr/bin/env bash

# Install nvm
{

set -e

if [[ $EUID -eq 0 ]]; then
  >&2 echo "[error] This script should not be run using sudo or the root user"
  exit 1
fi

CACHE_DIR='/home/vagrant/.cache'

mkdir -p $CACHE_DIR

# nvm
DEFAULT_NVM_VER='0.33.11'
NVM_VER="${INSTALL_NVM_VERSION:-$DEFAULT_NVM_VER}"
NVM_PATH="$CACHE_DIR/install-nvm-$NVM_VER.sh"

install_nvm () {
  if [[ ! -f $NVM_PATH ]]; then
    echo "[info] Package nvm downloading ..."
    curl -sL -k "https://raw.githubusercontent.com/creationix/nvm/v$NVM_VER/install.sh" -o $NVM_PATH > /dev/null 2>&1
  fi

  echo "[info] Package nvm installing $NVM_VER ..." &&
  bash $NVM_PATH
}

# install nvm
if ! command -v nvm > /dev/null; then
  install_nvm
else
  echo "[info] nvm ($(nvm --version)) is already installed"
fi

}
