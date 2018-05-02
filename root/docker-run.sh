#!/usr/bin/env bash
set -e

# Set timezone
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Set locale
export LC_ALL=${LANG}
export LANGUAGE=${LANG}

# Run supervisor
exec /usr/bin/supervisord
