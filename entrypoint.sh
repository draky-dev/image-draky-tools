#!/usr/bin/env bash

set -e

export DRAKY_DEBUG=${DRAKY_DEBUG:-0}

if [[ "${DRAKY_DEBUG}" == 1 ]]; then
    set -x
fi

# Make sure that required env variables are set
export DRAKY_TOOLS_CORE_BIN_PATH=${DRAKY_TOOLS_CORE_BIN_PATH:-/draky-tools.core.bin}
export DRAKY_TOOLS_CORE_INIT_PATH=${DRAKY_TOOLS_CORE_INIT_PATH:-/draky-tools.core.init.d}

export DRAKY_TOOLS_BIN_PATH=${DRAKY_TOOLS_BIN_PATH:-/draky-tools.bin}
export DRAKY_TOOLS_INIT_PATH=${DRAKY_TOOLS_INIT_PATH:-/draky-tools.init.d}

export DRAKY_TOOLS_RESOURCES_PATH=${DRAKY_TOOLS_RESOURCES_PATH:-/draky-tools.resources}


export PATH="$DRAKY_TOOLS_CORE_BIN_PATH:$PATH"

echo "$0: Running core initialization scripts."

for f in ${DRAKY_TOOLS_CORE_INIT_PATH}/*; do
	case "$f" in
		*.sh) echo "$0: running $f"; "$f" ;;
		*)    echo "$0: ignoring $f" ;;
	esac

	if [ "$?" != 0 ]; then
    echo "$f: FAILED"
    exit 1
  fi
done

echo "$0: Running extra initialization scripts."

for f in ${DRAKY_TOOLS_INIT_PATH}/*; do
	case "$f" in
		*.sh) echo "$0: running $f"; "$f" ;;
		*)    echo "$0: ignoring $f" ;;
	esac

	if [ "$?" != 0 ]; then
    echo "$f: FAILED"
    exit 1
  fi
done

DOCKER_USER=${DOCKER_USER:-root}

if [[ "$DOCKER_USER" == 'root' ]]; then
  # If user is root, just use the current shell.
  exec "$@"
  else
  # If user is someone other than root, then create a new login shell to run commands as him, and pass to him env variables.
  ( echo "set -a" ;env | grep -vE "^(PWD=|HOME=|SHLVL=)" ;echo "set +a" ;echo "cd ${PWD}" ) > /etc/profile.d/5-user-vars.draky-tools.sh
  exec sudo -i -u "${DOCKER_USER}" -- "$@"
fi
