# Handles the actual logging in of users by verifying credentials with the Account model.
class Login < ActiveRecord::Base
  attr_accessor :site_id, :email_address, :password, :match
  
  belongs_to :account
  
  before_validation :authenticate_account
  
  validates_presence_of :match, :message => 'for your Email Address and Password could not be found'
  
  after_save :ensure_account_is_not_pending_recovery
  
  private
  
  # A Login callback that ensures users with un-activated or banned accounts cannot login.
  def validate
    if self.match
      errors.add_to_base "Your account is not yet activated.  Please check your email inbox for your activation letter." if self.match.is_pending_activation?
      errors.add_to_base "Your account has been disabled. Please contact the site administrator for more information." if self.match.banned?
    end
  end
  
  # A Login callback that verifies that the email address and password given by a user is correct, and if so,
  # associates the matched Login to an account.  
  def authenticate_account
    self.password ||= ''
    self.match = Account.find_by_email_address_and_password(self.site_id, self.email_address, self.password)
    if self.match
      self.account_id ||= self.match.id
    end
  end
  
  # A login callback that clears the verification key from an account if a recovery was requested.  This is good if an account owner
  # requests a recovery, then remembers their password and logs in without clicking the link in the recovery letter.  
  def ensure_account_is_not_pending_recovery
    self.match.is_not_pending_recovery!
  end
end
