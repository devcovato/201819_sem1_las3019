#!/usr/bin/env bash

# Setup Truffle box

{

set -e

echo "[info] Truffle box creating..."
if ! command -v truffle > /dev/null; then
  >&2 echo "[error] Truffle command not available"
  >&2 echo
  exit 1
fi

# project
TRUFFLEBOX_PRJNAME="${TRUFFLEBOX_PRJNAME:-my-las3019}"
TRUFFLEBOX_NAME="${TRUFFLEBOX_NAME:-webpack}"
# host
HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED=~/sf_projects
HOST_TRUFFLEBOX_PRJNAME_PATH="$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED/$TRUFFLEBOX_PRJNAME"
HOST_TRUFFLEBOX_PRJNAME_LOCK_FILE="$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED/.$TRUFFLEBOX_PRJNAME.lock"
# guest
GUEST_TRUFFLEBOX_PROJECTS_ROOT=~/projects
GUEST_TRUFFLEBOX_PRJNAME_PATH="$GUEST_TRUFFLEBOX_PROJECTS_ROOT/$TRUFFLEBOX_PRJNAME"
# tmp
TRUFFLEBOX_TMP="/tmp/${TRUFFLEBOX_PRJNAME}-tmp"
# npm deps configuration
CHROMEDRIVER_SKIP_DOWNLOAD=true

# Check lock file
if [[ -f "$HOST_TRUFFLEBOX_PRJNAME_LOCK_FILE" ]]; then
  echo "[info] Trufflex box '$TRUFFLEBOX_PRJNAME' already created"
  exit 0
fi

echo "[info] Set up truffle project '$TRUFFLEBOX_PRJNAME' using box '$TRUFFLEBOX_NAME'..."

# Prepare guest 'projects' folder
mkdir -p $GUEST_TRUFFLEBOX_PROJECTS_ROOT

# Prepare and run truffle unbox 'box' in 'temp' folder
rm -rf $TRUFFLEBOX_TMP
mkdir -p $TRUFFLEBOX_TMP
cd $TRUFFLEBOX_TMP
truffle unbox $TRUFFLEBOX_NAME

# Copy contents
# -- *NOTE* This action is destructive
rm -rf $HOST_TRUFFLEBOX_PRJNAME_PATH
mkdir -p $HOST_TRUFFLEBOX_PRJNAME_PATH
find . -type f -not -path "*node_modules*" -exec cp --parents '{}' "$HOST_TRUFFLEBOX_PRJNAME_PATH" \;

# Finalize truffle box
find $HOST_TRUFFLEBOX_PRJNAME_PATH -type f -name 'package.json' -not -path '*node_modules*' | while read -r pkgjson_file;
do
  app_path="$(dirname $pkgjson_file)"
  base_app_path="${app_path#$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED\/}"
  guest_app_path="$GUEST_TRUFFLEBOX_PROJECTS_ROOT/$base_app_path"
  host_app_path="$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED/$base_app_path"

  # Check if exists 'node_modules' folder
  if [[ ! -d "$guest_app_path/node_modules" ]]; then
    rm -rf $guest_app_path
    mkdir -p "$guest_app_path/node_modules"
  fi

  # Check if target folder is not a symlink
  if [[ ! -h "$host_app_path/node_modules" ]]; then
    rm -rf "$host_app_path/node_modules"
  fi

  # Recreate the link
  ln -sfT "$guest_app_path/node_modules" "$host_app_path/node_modules"

  # Install npm deps
  cd $host_app_path
  npm install -s
done

echo "[info] '$prj_box' ready"

# create lock file
touch "$HOST_TRUFFLEBOX_PRJNAME_LOCK_FILE"
echo "Truffle box: $TRUFFLEBOX_NAME" >> "$HOST_TRUFFLEBOX_PRJNAME_LOCK_FILE"

exit 0
}
