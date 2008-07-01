require 'digest/sha2'

class Account < ActiveRecord::Base
  attr_reader :password
  
  ENCRYPT = Digest::SHA256
  
  validates_uniqueness_of :email_address,
                          :message => 'must be unique'
  
  validates_format_of :email_address, :with => /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}/i,
                      :message => "must be valid (e.g. name@domain.com)"
  
  validates_format_of :password, :with => /^([\x20-\x7E]){6,}$/,
                      :unless => :password_is_not_being_updated,
                      :message => "must be six or more characters"
  
  validates_confirmation_of :password,
                            :message => 'must match Password Confirmation'
  
  after_save :flush_passwords
  
  def self.find_by_credentials(credentials)
    account = self.find_by_email_address(credentials[:email_address])
    if account and account.encrypted_password == ENCRYPT.hexdigest(credentials[:password] + account.salt)
      return account
    end
  end
  
  def password=(password)
    @password = password
    unless password_is_not_being_updated
      self.salt = [Array.new(6){rand(256).chr}.join].pack('m').chomp
      self.encrypted_password = ENCRYPT.hexdigest(password + self.salt)
    end
  end
  
  def verify_password(password)
    ENCRYPT.hexdigest(password + self.salt) == self.encrypted_password
  end
  
  private
  
  def password_is_not_being_updated
    ! self.new_record? and self.password.blank?
  end
    
  def flush_passwords
    @password = @password_confirmation = nil
  end
end
