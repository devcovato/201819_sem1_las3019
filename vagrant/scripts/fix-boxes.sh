#!/usr/bin/env bash

# Fix broken boxes due to missing symlink

{

set -e

echo "[info] Truffle box fixing..."
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

# Prepare guest 'projects' folder
mkdir -p $GUEST_TRUFFLEBOX_PROJECTS_ROOT

# Recreate guest project folder only for locked ones
find "$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED" -maxdepth 1 -type d \( ! -path "$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED" -prune \) | while read -r prj_path;
do
  prj_box="$(basename $prj_path)"
  if [[ -f "$HOST_TRUFFLEBOX_PROJECTS_ROOT_MOUNTED/.$prj_box.lock" ]]; then
    echo "[info] '$prj_box' recreating and installing node modules..."
    # Loop package.json
    find $prj_path -type f -name 'package.json' -not -path '*node_modules*' | while read -r pkgjson_file;
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

      if [[ -n "$(find "$host_app_path/node_modules/" -maxdepth 0 -type d -empty 2>/dev/null)" ]]; then
        cd $host_app_path
        npm install -s
        echo "[info] 'npm install' done"
      fi
    done

    echo "[info] '$prj_box' ready"
    echo
  fi
done

}
