require 'active_record'
require 'digest/sha1'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "lib/mole.db"
)

class User < ActiveRecord::Base
  has_many :entries
  attr_accessor :password
  validates_presence_of :email, :crypted_password, :salt
  
  def before_validation
    encrypt_password if password
  end
  
  def after_save
    password = nil
  end
  
  def authenticate?(password)
    Digest::SHA1.hexdigest("--#{self.salt}--#{password}--") == self.crypted_password
  end
  
  private
    def encrypt_password
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.email}--")
      self.crypted_password = Digest::SHA1.hexdigest("--#{self.salt}--#{password}--")
    end
end

class Client < ActiveRecord::Base
  has_many :projects
  has_many :contacts
  has_many :notes
  validates_presence_of :name
end

class Project < ActiveRecord::Base
  belongs_to :client
  has_many :entries
  validates_presence_of :name, :client
  def after_create
    self.client.notes.create(:message => "Created new project called #{self.name}")
  end
  def after_destroy
    self.client.notes.create(:message => "Removed project called #{self.name}")
  end
  def hours_spent
    total = 0
    self.entries.each{|x| total += x.hours}
    total
  end
end

class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  validates_presence_of :user, :project, :message, :hours
end

class Contact < ActiveRecord::Base
  belongs_to :client
  validates_presence_of :name
  def after_create
    self.client.notes.create(:message => "Created new person called #{self.name}")
  end
  def after_destroy
    self.client.notes.create(:message => "Removed person called #{self.name}")
  end
end

class Note < ActiveRecord::Base
  belongs_to :client
  validates_presence_of :message
end

