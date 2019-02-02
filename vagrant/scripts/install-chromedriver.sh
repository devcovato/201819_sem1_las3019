#!/usr/bin/env bash

{

set -e

if [[ $EUID -ne 0 ]]; then
  >&2 echo "[error] This script should be run using sudo or the root user"
  exit 1
fi

# chromedriver
if ! command -v chromedriver > /dev/null; then
  echo "[info] Install Chrome Driver..."

  CHROMEDRIVER_VERSION=${CHROMEDRIVER_VERSION:-LATEST_RELEASE}

  if [[ "$CHROMEDRIVER_VERSION" -eq 'LATEST_RELEASE' ]]; then
    CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
  fi

  mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
  curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
  unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
  rm /tmp/chromedriver_linux64.zip && \
  chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
  ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver
else
  echo "[info] Chrome Driver already installed"
fi

}
