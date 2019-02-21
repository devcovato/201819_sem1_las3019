#!/usr/bin/env bash

# Setup Truffle box

set -e

# Global dependencies version
NODE_GYP_VERSION='3.8.0'
TRUFFLE_VERSION='5.0.2'
SOLCJS_VERSION='0.4.25'
GANACHE_CLI_VERSION='6.3.0'

# Current versions installed
CURR_NPM_PKGS_VERSION="$(npm -g list --depth=0)"

# node-gyp
if ! command -v node-gyp > /dev/null; then
  echo "[info] Install node-gyp@$NODE_GYP_VERSION..."
  npm install -g -s node-gyp@$NODE_GYP_VERSION
elif [[ $(echo $CURR_NPM_PKGS_VERSION > grep -c "node-gyp@$NODE_GYP_VERSION") -eq 0 ]]; then
  echo "[info] Upgrading node-gyp to $NODE_GYP_VERSION..."
  npm install -g -s node-gyp@$NODE_GYP_VERSION
else
  echo "[info] node-gyp is already installed"
fi
# truffle
if ! command -v truffle > /dev/null; then
  echo "[info] Install truffle@$TRUFFLE_VERSION..."
  npm install -g -s truffle@$TRUFFLE_VERSION
elif [[ $(echo $CURR_NPM_PKGS_VERSION > grep -c "truffle@$TRUFFLE_VERSION") -eq 0 ]]; then
  echo "[info] Upgrading truffle to $TRUFFLE_VERSION..."
  npm install -g -s truffle@$TRUFFLE_VERSION
else
  echo "[info] truffle is already installed"
fi
# solcjs
if ! command -v solcjs > /dev/null; then
  echo "[info] Install solc@$SOLCJS_VERSION ..."
  npm install -g -s solc@$SOLCJS_VERSION
elif [[ $(echo $CURR_NPM_PKGS_VERSION > grep -c "solc@$SOLCJS_VERSION") -eq 0 ]]; then
  echo "[info] Upgrading solc to $SOLCJS_VERSION..."
  npm install -g -s solc@$SOLCJS_VERSION
else
  echo "[info] solc is already installed"
fi
# ganache-cli (ex ethereum-testrpc)
if ! command -v ganache-cli > /dev/null; then
  echo "[info] Install ganache-cli@$GANACHE_CLI_VERSION ..."
  npm install -g -s ganache-cli@$GANACHE_CLI_VERSION
elif [[ $(echo $CURR_NPM_PKGS_VERSION > grep -c "solc@$GANACHE_CLI_VERSION") -eq 0 ]]; then
  echo "[info] Upgrading ganache-cli to $GANACHE_CLI_VERSION..."
  npm install -g -s ganache-cli@$GANACHE_CLI_VERSION
else
  echo "[info] ganache-cli is already installed"
fi
