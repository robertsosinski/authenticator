require 'digest/sha2'

# Handles information neccessary to verify and manage users of a application, namely, their email address and password (which is encrypted).
class Account < ActiveRecord::Base
  attr_accessor :password
  
  ENCRYPT = Digest::SHA256
  
  has_many :logins, :dependent => :destroy
  
  belongs_to :site, :counter_cache => true
  
  validates_uniqueness_of :email_address, :scope => 'site_id',
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
  
  # Finds an account by an email address and then verifies it with a password.
  def self.find_by_email_address_and_password(site_id, email_address, password)
    account = self.find_by_email_address(email_address, :conditions => {:site_id => site_id})
    if account and account.encrypted_password == ENCRYPT.hexdigest(password + account.salt)
      return account
    end
  end
  
  # Finds an account by an id and then verifies it with the verification key generated during creation or recovery.
  def self.find_by_id_and_verification_key(id, verification_key)
    ##
    # It is very important to check if the verification_key is nil or else passing a nil
    # for the verification_key through the API will allow an API user to login as anyone!!!
    ##
    verification_key.nil? ? nil : self.find_by_id(id, :conditions => {:verification_key => verification_key})
  end
  
  # Finds all accounts that belong to a site that start with a given letter.
  # If no letter is given, it will return all accounts for a site.
  def self.find_by_site_id_and_letter(site_id, letter)
    if letter == '#'
      @accounts = Account.find(:all, :conditions => ["email_address REGEXP ? AND site_id = ?", "^[^a-z]", site_id], :order => 'email_address')
    else
      @accounts = Account.find(:all, :conditions => ["email_address LIKE ? AND site_id = ?", "#{letter}%", site_id], :order => 'email_address')
    end
  end
  
  # Generates a random 8 character Base64 salt and uses it to encrypt the given password with SHA256.
  def password=(password)
    @password = password ||= ''
    @password_confirmation ||= ''
    unless skip_password_encryption_and_validation?
      self.salt = [Array.new(6){rand(256).chr}.join].pack('m').chomp
      self.encrypted_password = ENCRYPT.hexdigest(password + self.salt)
    end
  end
  
  # Lets a console user verify a password.
  #
  #  # Password is 'super secret'
  #  @account.password_is?('secret') => false
  #  @account.password_is?('super secret') => true
  def password_is?(password)
    ENCRYPT.hexdigest(password + self.salt) == self.encrypted_password
  end
  
  # Returns true if the Account is pending activation.
  def is_pending_activation?
    ! self.activated? and self.verification_key ? true : false
  end
  
  # Activates an Account
  def activate!
    self.update_attributes(:activated => true, :verification_key => nil) if self.is_pending_activation?
  end  
  
  # Returns true if the Account is pending recovery.
  def is_pending_recovery?
    self.activated? and self.verification_key ? true : false
  end
  
  # Sets the Account as pending recovery.
  def is_pending_recovery!
    self.update_attribute(:verification_key, KeyGenerator.create)
  end
  
  # Sets an Account pending recovery as no longer pending recovery.
  # Will make no changes to an Account that is not pending recovery.
  def is_not_pending_recovery!
    self.update_attribute(:verification_key, nil) if self.is_pending_recovery?
  end
  
  # Sets an Account as being banned. 
  def ban!
    self.update_attribute(:banned, true)
  end
  
  # Removes ban status from an Account.
  def unban!
    self.update_attribute(:banned, false)
  end
    
  private
  
  # Checks if the Account is being updated without a password, and if it is,
  # assums the Account owner does not want to change their password.
  def skip_password_encryption_and_validation?
    self.id and self.password.blank?
  end
  
  # Removes the plain text password and password confirmation from the system
  def flush_passwords
    @password = @password_confirmation = nil
  end
  
  # Saves a randomly generated verification key to the specified account.
  def save_verification_key
    self.verification_key = KeyGenerator.create
  end
end
