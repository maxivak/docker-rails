#!/bin/bash

SIDEKIQ_THREADS=${SIDEKIQ_THREADS:-16}

APP_DIR="${APP_DIR:-default '/home/app/webapp'}"

cd $APP_DIR


bundle show sidekiq || sleep infinity

SIDEKIQ_CONFIG="${APP_DIR}/config/sidekiq.yml"
if [ ! -f $SIDEKIQ_CONFIG ]; then
  SIDEKIQ_CONFIG="/etc/sidekiq.yml"
fi

/opt/wait-for-syslog.sh
exec chpst -u app bundle exec sidekiq -t 5 -c $SIDEKIQ_THREADS -C $SIDEKIQ_CONFIG \
  2>&1 |logger -t sidekiq
