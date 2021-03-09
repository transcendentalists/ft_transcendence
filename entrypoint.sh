#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

yarn install --check-files && bundle exec rake db:exists && bundle rake db:migrate || bundle exec "$@"
