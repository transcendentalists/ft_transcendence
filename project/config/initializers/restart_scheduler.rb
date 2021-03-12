if defined?(Rails::Server)
  Tournament.retry_set_schedule
  War.retry_set_schedule
end
