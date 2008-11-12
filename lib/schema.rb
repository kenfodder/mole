require 'active_record'

class Schema < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('users')
    
    create_table :entries do |t|
      t.integer :user_id
      t.integer :project_id
      t.float   :hours
      t.string  :message
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('entries')
    
    create_table :projects do |t|
      t.string  :name
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('projects')
  end

  def self.down
    drop_table :users if ActiveRecord::Base.connection.tables.include?('users')
    drop_table :entries if ActiveRecord::Base.connection.tables.include?('entries')
    drop_table :projects if ActiveRecord::Base.connection.tables.include?('projects')
  end
  
end
