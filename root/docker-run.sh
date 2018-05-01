#!/usr/bin/env bash
set -e

# Set timezone
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Run supervisor
exec /usr/bin/supervisord
