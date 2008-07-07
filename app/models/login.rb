class Login < ActiveRecord::Base
	attr_accessor :email_address, :password, :match
	
	belongs_to :account
	
	before_validation :authenticate_account
	
	validates_presence_of :match, :message => 'for your Email Address and Password could not be found'
 
	private
 
	def authenticate_account
	  self.password ||= ''
		self.match = Account.find_by_email_address_and_password(self.email_address, self.password)
		if self.match
		  self.account_id ||= self.match.id
	  end
	end
end
