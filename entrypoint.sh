#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

(bundle exec rake db:connection_exists && bundle exec rake db:migrate) || (bundle exec rake db:create && bundle rake db:migrate)

# seed 데이터가 셋팅된 적 없다면, seed 데이터 셋팅
bundle exec rake db:is_first_time && bundle exec rake db:seed

yarn install --check-files && bundle exec "$@"
