#!/bin/bash

APP_DIR="${APP_DIR:-default '/home/app/webapp'}"

cd $APP_DIR


if bundle show rails_migrate_mutex; then
  chpst -u app bundle exec rake db:migrate:mutex
fi
