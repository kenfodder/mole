require 'active_record'

class Schema < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :email, :null => false
      t.string :salt, :null => false
      t.string :crypted_password, :null => false
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('users')
    
    create_table :clients do |t|
      t.string :name, :null => false
      t.string :image_url
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('clients')
    
    create_table :projects do |t|
      t.integer :client_id, :null => false
      t.string  :name, :null => false
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('projects')
    
    create_table :entries do |t|
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
      t.decimal :hours, :null => false
      t.string  :message, :null => false
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('entries')
    
    create_table :contacts do |t|
      t.integer :client_id, :null => false
      t.string  :name, :null => false
      t.string  :telephone
      t.string  :image_url
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('contacts')
    
    create_table :notes do |t|
      t.integer :client_id, :null => false
      t.integer :user_id
      t.text    :message
      t.timestamps
    end unless ActiveRecord::Base.connection.tables.include?('notes')
  end

  def self.down
    drop_table :users if ActiveRecord::Base.connection.tables.include?('users')
    drop_table :entries if ActiveRecord::Base.connection.tables.include?('entries')
    drop_table :projects if ActiveRecord::Base.connection.tables.include?('projects')
    drop_table :clients if ActiveRecord::Base.connection.tables.include?('clients')
    drop_table :contacts if ActiveRecord::Base.connection.tables.include?('contacts')
    drop_table :notes if ActiveRecord::Base.connection.tables.include?('notes')
  end
  
end
