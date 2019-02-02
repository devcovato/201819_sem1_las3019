#!/usr/bin/env bash

{

set -e

if [[ $EUID -ne 0 ]]; then
  >&2 echo "[error] This script should be run using sudo or the root user"
  exit 1
fi

# phantomjs
if ! command -v phantomjs > /dev/null; then
  echo "[info] Install phantomjs..."

  DEBIAN_FRONTEND=noninteractive \
    apt-get -qqy install fontconfig

  PHANTOMJS_VERSION=${PHANTOMJS_VERSION:-2.1.1}

  mkdir -p /opt/phantomjs-$PHANTOMJS_VERSION && \
  curl -sS -L -o /tmp/phantomjs-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xf /tmp/phantomjs-linux-x86_64.tar.bz2 --directory /opt/phantomjs-$PHANTOMJS_VERSION && \
  cp -R "$(find /opt/phantomjs-$PHANTOMJS_VERSION -depth -maxdepth 1 -type d | head -n 1)"/* /opt/phantomjs-$PHANTOMJS_VERSION && \
  rm /tmp/phantomjs-linux-x86_64.tar.bz2 && \
  chmod +x /opt/phantomjs-$PHANTOMJS_VERSION/bin/phantomjs && \
  ln -fs /opt/phantomjs-$PHANTOMJS_VERSION/bin/phantomjs /usr/local/bin/phantomjs
else
  echo "[info] phantomjs already installed"
fi

}
