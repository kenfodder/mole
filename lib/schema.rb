require 'active_record'

class Schema < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :email
      t.string :salt
      t.string :crypted_password
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('users')
    
    create_table :clients do |t|
      t.string :name
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('clients')
    
    create_table :projects do |t|
      t.integer :client_id
      t.string  :name
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('projects')
    
    create_table :entries do |t|
      t.integer :user_id
      t.integer :project_id
      t.decimal :hours
      t.string  :message
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('entries')
    
  end

  def self.down
    drop_table :users if ActiveRecord::Base.connection.tables.include?('users')
    drop_table :entries if ActiveRecord::Base.connection.tables.include?('entries')
    drop_table :projects if ActiveRecord::Base.connection.tables.include?('projects')
    drop_table :clients if ActiveRecord::Base.connection.tables.include?('clients')
  end
  
end
