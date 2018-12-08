#!/usr/bin/env bash

# Setup Truffle box

{

set -e

echo "Truffle box creating ..."
if ! command -v truffle > /dev/null; then
  >&2 echo "[error] Truffle command not available"
  >&2 echo
  exit 1
fi

TRUFFLEBOX_PRJNAME="${TRUFFLEBOX_PROJECT_NAME:-trufflebox-webpack}"
# host
TRUFFLEBOX_SF_PROJECTS_ROOT=~/sf_projects
TRUFFLEBOX_PRJNAME_HOST_PATH="$TRUFFLEBOX_SF_PROJECTS_ROOT/$TRUFFLEBOX_PRJNAME"
TRUFFLEBOX_PRJNAME_HOST_PATH_NODE_MODULES="$TRUFFLEBOX_PRJNAME_HOST_PATH/node_modules"
TRUFFLEBOX_PRJNAME_LOCK_FILE="$TRUFFLEBOX_SF_PROJECTS_ROOT/.${TRUFFLEBOX_PRJNAME}.lock"
# guest
TRUFFLEBOX_PROJECTS_ROOT=~/projects
TRUFFLEBOX_PRJNAME_PATH="$TRUFFLEBOX_PROJECTS_ROOT/$TRUFFLEBOX_PRJNAME"
TRUFFLEBOX_PRJNAME_PATH_NODE_MODULES="$TRUFFLEBOX_PRJNAME_PATH/node_modules"

TRUFFLEBOX_TMP="/tmp/${TRUFFLEBOX_PRJNAME}-tmp"

if [[ -f "$TRUFFLEBOX_PRJNAME_LOCK_FILE" ]]; then
  exit 0
fi

# Prepare and run truffle unbox command
rm -rf $TRUFFLEBOX_TMP
mkdir -p $TRUFFLEBOX_TMP
cd $TRUFFLEBOX_TMP
truffle unbox webpack
# Create shareable node_modules folder
rm -rf $TRUFFLEBOX_PRJNAME_PATH_NODE_MODULES
mkdir -p $TRUFFLEBOX_PRJNAME_PATH_NODE_MODULES
# Copy contents
# -- *NOTE* This action is destructive
rm -rf $TRUFFLEBOX_PRJNAME_HOST_PATH
mkdir -p $TRUFFLEBOX_PRJNAME_HOST_PATH
cp -r `ls -A | grep -v "node_modules"` "$TRUFFLEBOX_PRJNAME_HOST_PATH/"
cd $TRUFFLEBOX_PRJNAME_HOST_PATH
ln -sfT "$TRUFFLEBOX_PRJNAME_PATH_NODE_MODULES" "$TRUFFLEBOX_PRJNAME_HOST_PATH_NODE_MODULES"
# install deps
npm install
# create lock file
touch "$TRUFFLEBOX_PRJNAME_LOCK_FILE"

}
