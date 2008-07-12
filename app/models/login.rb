class Login < ActiveRecord::Base
	attr_accessor :email_address, :password, :match
	
	belongs_to :account
	
	before_validation :authenticate_account
	
	validates_presence_of :match, :message => 'for your Email Address and Password could not be found'
	
	after_save :ensure_account_is_not_pending_recovery # If the user can login, then they no longer need their account recovered.
	
  def validate
    if self.match
      errors.add_to_base "Your account is not yet activated.  Please check your email inbox for your activation letter." if self.match.is_pending_activation?
      errors.add_to_base "Your account has been disabled. Please contact the site administrator for more information." if self.match.banned?
    end
  end
 
	private
 
	def authenticate_account
	  self.password ||= ''
		self.match = Account.find_by_email_address_and_password(self.email_address, self.password)
		if self.match
		  self.account_id ||= self.match.id
	  end
	end
	
	def ensure_account_is_not_pending_recovery
	  self.match.is_not_pending_recovery!
  end
end
