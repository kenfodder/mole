require 'active_record'
require 'digest/sha1'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "lib/mole.db"
)

class User < ActiveRecord::Base
  has_many :entries
  attr_accessor :password
  
  def before_save
    self.crypted_password = password
  end
  
  def after_save
    @password = nil
  end
  
  def authenticate?(password)
    password == self.crypted_password
  end
  
end

class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end

class Project < ActiveRecord::Base
end