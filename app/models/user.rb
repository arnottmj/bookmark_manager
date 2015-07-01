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
  property :email, String, unique: true, message: 'This email is already taken'
  property :password_digest, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email:, password:) # clearly there is an issue here.. but let's wait until we have a test that targets it
    user = User.first(email: email)

    if user && BCrypt::Password.new(user.password_digest) == password
      # return this user
      user
    else
      nil
    end
  end

end
