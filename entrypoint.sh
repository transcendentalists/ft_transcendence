#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rake db:connection_exists && bundle exec rake db:migrate

yarn install --check-files && bundle exec "$@"
