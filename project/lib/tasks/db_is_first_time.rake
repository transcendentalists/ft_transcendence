namespace :db do
  desc "Checks to see if 'db:seed' command has been executed"
  task :is_first_time do
    begin
      User.find(1)
    rescue
      exit 1
    else
      exit 0
    end
  end
end