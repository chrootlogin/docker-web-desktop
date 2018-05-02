#!/usr/bin/env bash
set -e

# Set timezone
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Set locale
export LC_ALL=${LANG}
export LANGUAGE=${LANG}

# Disable sudo if requested
if [ "${DISABLE_SUDO}" == "true" ]; then
  rm -f /etc/sudoers.d/user-nopasswd
  echo "SUDO disabled!"
fi

# Run supervisor
exec /usr/bin/supervisord
