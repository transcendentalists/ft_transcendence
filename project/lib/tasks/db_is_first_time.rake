namespace :db do
  desc "Checks to see if 'db:seed' command has been executed"
  task :is_first_time do
    begin
      User.find(1)
    rescue
      # db:seed never executed and User(web_owner) record wasn't created.
      # Therefore it is first_time to build DB and Web.
      exit 0
    else
      exit 1
    end
  end
end