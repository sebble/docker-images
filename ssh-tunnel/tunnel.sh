#!/bin/sh

: ${REMOTE_HOST:?}
: ${REMOTE_USER:=$USER}
: ${REMOTE_PORT:=22}
: ${REMOTE_TUNNEL:?}

test -f ~/.ssh/known_hosts || {
    echo
    echo "Warning: Unsafe - fetching remote host keys."
    echo "         Provide a ~/.ssh/known_hosts file."
    echo
    ssh-keyscan $REMOTE_HOST >> ~/.ssh/known_hosts
    echo
}

set -x

exec ssh \
    -p $REMOTE_PORT \
    -o ServerAliveInterval=60 \
    -N \
    -R $REMOTE_TUNNEL \
    $SSH_OPTIONS \
    $REMOTE_USER@$REMOTE_HOST
