namespace :db do
  desc "Checks to see if the database exists"
  task :connection_exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      exit 1
    else
      exit 0
    end
  end
end