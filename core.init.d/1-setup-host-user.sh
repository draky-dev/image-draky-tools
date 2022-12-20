#!/usr/bin/env bash

echo "$0: Setting up host user."

if [ -z ${DOCKER_HOST_UID+x} ] || [ -z ${DOCKER_HOST_GID+x} ]; then
    echo "$0: DOCKER_HOST_UID or DOCKER_HOST_GID is unavailable. Skipping creating host user in the container." >&2
    exit 0
fi

export DOCKER_HOST_USERNAME=host
export DOCKER_HOST_GROUP="${DOCKER_HOST_USERNAME}"

EXISTING_USER="$(getent passwd ${DOCKER_HOST_UID} | cut -d: -f1)"

# If user with the same UID already exists in container, then remove him.
if [[ "${EXISTING_USER}" != '' ]]; then
    deluser ${EXISTING_USER}
fi

# Create host group if fitting group doesn't already exist.
if [ ! $(getent group ${DOCKER_HOST_GID}) ]; then
    addgroup -g "${DOCKER_HOST_GID}" "${DOCKER_HOST_GROUP}"
    else
    DOCKER_HOST_GROUP="$(getent group ${DOCKER_HOST_GID} | sed -E "s/^([a-z]+):.*$/\1/")"
fi

# Create host user.
adduser -u "${DOCKER_HOST_UID}" -G "${DOCKER_HOST_GROUP}" -g "Docker host" -D "${DOCKER_HOST_USERNAME}" -s /bin/sh
