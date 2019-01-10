#!/usr/bin/env bash

# Setup Truffle box

{

set -e

# node-gyp
if ! command -v node-gyp > /dev/null; then
  npm install -g -s node-gyp
else
  echo "[info] node-gyp is already installed"
fi
# web3.js
if [[ $(npm -g ls --depth=0 > /dev/null | grep -c 'web3') -eq 1 ]]; then
  echo "[info] Install web3@0.20.7 ..."
  npm install -g -s web3@0.20.7
else
  echo "[info] web3 is already installed"
fi
# truffle
if ! command -v truffle > /dev/null; then
  echo "[info] Install truffle..."
  npm install -g -s truffle
else
  echo "[info] truffle is already installed"
fi
# solcjs
if ! command -v solcjs > /dev/null; then
  echo "[info] Install solc@0.4.25 ..."
  npm install -g -s solc@0.4.25
else
  echo "[info] solc is already installed"
fi
# ganache-cli (ex ethereum-testrpc)
if ! command -v ganache-cli > /dev/null; then
  echo "[info] Install ganache-cli@6.2.3 ..."
  npm install -g -s ganache-cli@6.2.3
else
  echo "[info] ganache-cli is already installed"
fi

}
