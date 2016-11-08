#!/bin/bash

# /usr/sbin/sshd -D
service rsyslog start

if [ "$DOCKER_COMPOSE" == "" ] ; then
  /bin/bash
else
  service stns start
  while true ; do
    sleep 5
  done
fi
