#!/bin/bash

APP_DIR="${APP_DIR:-default '/home/app/webapp'}"

cd $APP_DIR

bundle show clockwork || sleep infinity

/opt/wait-for-syslog.sh
exec chpst -u app bundle exec rails runner /etc/clockwork.rb \
  2>&1 |logger -t clockwork
