require 'digest/sha2'

class Account < ActiveRecord::Base
  attr_accessor :password
  
  ENCRYPT = Digest::SHA256
  
  has_many :logins
  
  validates_uniqueness_of :email_address,
                          :message => 'must be unique'
  
  validates_format_of :email_address, :with => /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}/i,
                      :message => "must be valid (e.g. name@domain.com)"
  
  validates_format_of :password, :with => /^([\x20-\x7E]){6,}$/,
                      :unless => :skip_password_encryption_and_validation?,
                      :message => "must be six or more characters"
  
  validates_confirmation_of :password,
                            :message => 'must match Password Confirmation'
  
  after_validation :flush_passwords
  
  before_create :save_verification_key
  
  def self.find_by_email_address_and_password(email_address, password)
    account = self.find_by_email_address(email_address)
    if account and account.encrypted_password == ENCRYPT.hexdigest(password + account.salt)
      return account
    end
  end
  
  def password=(password)
    @password = password ||= ''
    @password_confirmation ||= ''
    unless skip_password_encryption_and_validation?
      self.salt = [Array.new(6){rand(256).chr}.join].pack('m').chomp
      self.encrypted_password = ENCRYPT.hexdigest(password + self.salt)
    end
  end
  
  def password_is?(password)
    ENCRYPT.hexdigest(password + self.salt) == self.encrypted_password
  end
  
  def inactive?
    ! self.active?
  end
  
  def activate!
    self.update_attribute(:active, true)
  end
  
  def deactivate!
    self.update_attribute(:active, false)
  end
  
  def is_pending_activation?
    self.inactive? and self.verification_key ? true : false
  end
  
  def is_pending_recovery?
    self.active? and self.verification_key ? true : false
  end
  
  def clear_verification_key!
    self.update_attribute(:verification_key, nil)
  end
  
  def ensure_verification_key_is_cleared!
    self.update_attribute(:verification_key, nil) if self.verification_key?
  end
  
  def activate_and_clear_verification_key!
    self.update_attributes(:active => true, :verification_key => nil)
  end
  
  private
  
  def skip_password_encryption_and_validation?
    self.id and self.password.blank?
  end
  
  def flush_passwords
    @password = @password_confirmation = nil
  end
  
  def save_verification_key
    self.verification_key = KeyGenerator.create(64)
  end
end
