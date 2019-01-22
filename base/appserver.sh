#!/bin/bash

#APP_DIR="${APP_DIR:/home/app/webapp}"
#APP_DIR="${APP_DIR:-default '/home/app/webapp'}"
APP_DIR="/home/app/webapp"

cd $APP_DIR

/opt/wait-for-syslog.sh
exec chpst -u app bundle exec puma -C /etc/puma.rb 2>&1 | logger -t appserver
