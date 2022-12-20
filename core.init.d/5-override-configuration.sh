#!/usr/bin/env bash

echo "$0: Overriding configuration."

OVERRIDE_PATH="${DRAKY_TOOLS_RESOURCES_PATH}/override"

if [ ! -d "${OVERRIDE_PATH}" ]; then
  echo "$0: Directory '${OVERRIDE_PATH}' doesn't exist." >&2
  exit 0
fi

IFS=$'\n'
for i in $(find "${OVERRIDE_PATH}" -type f); do

  TARGET=${i#"$OVERRIDE_PATH"}
  RESULT=$(template.draky-tools.sh -t "${i}")

  echo "$RESULT" > "${TARGET}"
done
unset IFS
