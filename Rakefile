Dir["lib/*.rb"].each { |x| load x }

task :default do
  puts 'rake mole:init           to get started'
  puts 'rake mole:reset          to reload the db schema (loses all data!)'
end

namespace :mole do
  
  task :db_up do
    Schema.up
  end
  
  task :db_down do
    Schema.down
  end
  
  task :init => :db_up do
     User.create(:email => 'admin@admin.com', :password => 'admin')
  end
  
  task :reset => [:db_down, :init]
  
end
