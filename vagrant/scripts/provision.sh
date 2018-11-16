#!/usr/bin/env bash

# Provisioning the Ethereum development machine

set -e

apt-get update --fix-missing

# nodejs
if ! command -v node > /dev/null; then
  echo "Install nodejs..."
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi
# go ethereum
if ! command -v geth > /dev/null; then
  echo "Install Go Ethereum..."
  add-apt-repository -y ppa:ethereum/ethereum
  apt-get update
  apt-get install -y ethereum
fi
# ganache-cli (ex ethereum-testrpc)
if ! command -v ganache-cli > /dev/null; then
  echo "Install ganache-cli..."
  npm install -g ganache-cli
fi
# node-gyp
if ! command -v node-gyp > /dev/null; then
  apt-get install -y gcc
  npm install -g node-gyp
fi
# web3.js
echo "Install web3..."
npm install -g web3@0.20.1
# truffle
if ! command -v truffle > /dev/null; then
  echo "Install truffle..."
  npm install -g truffle
fi
# solcjs
if ! command -v solcjs > /dev/null; then
  echo "Install solcjs..."
  npm install -g solc@0.4.25
fi
