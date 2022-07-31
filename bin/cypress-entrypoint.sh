#!/bin/sh

set -e

yarn install
yarn run cypress install

exec "$@"
