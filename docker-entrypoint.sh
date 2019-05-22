#! /bin/sh

set -eux

BORGUSER_UID=${BORGUSER_UID:-0}
BORGUSER_GID=${BORGUSER_GID:-$BORGUSER_UID}

if [ $BORGUSER_UID -gt 0 ]; then
   # alpine, busybox 
   # https://busybox.net/downloads/BusyBox.html
   addgroup -g $BORGUSER_GID borg
   adduser -D -h /home/borg -s /bin/bash -u $BORGUSER_UID -G borg borg
   exec gosu borg "$@"
else
   # run as root or whatever effective user
   exec "$@"
fi

