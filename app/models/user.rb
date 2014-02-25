class User < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes

  attribute :email
  unique :email
  index :email

  attribute :crypted_password
  attribute :role

  def self.authenticate(email, _password)
    u = User.find(email: email).first
    puts u.crypted_password, crypt_password(_password), u.crypted_password == crypt_password(_password)
    return u if u and u.crypted_password == crypt_password(_password)
    return nil
  end

  def self.crypt_password(_password)
    Base64.encode64(Digest::SHA256.new.digest(_password))
  end

  def password=(_password)
    self.crypted_password = self.class.crypt_password(_password)
  end

  def admin?
    self.role == "admin"
  end
end