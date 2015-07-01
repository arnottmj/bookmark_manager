require 'data_mapper'
require 'bcrypt'
require 'dm-validations'

class User
  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password
  # validates_uniqueness_of :email ## No longer needed as we have set email to have a unique index with unique: true

  property :id, Serial
  property :email, String, unique: true
  property :password_digest, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

end
