# Stores and manages the data required to verify API and admin panel users.
#
# Stores and manages email subjects and letters used for account activation and recovery.
class Site < ActiveRecord::Base
  has_many :accounts, :dependent => :destroy
  
  validates_presence_of :email_address, :support_title,
                        :invitation_subject, :activation_subject, :recovery_subject,
                        :invitation_letter, :activation_letter, :recovery_letter
  
  # Finds the site by the given domain, and verifies it with an API key.
  #
  #  # if given valid attributes
  #  Site.authenticate('capansis.com', '2aae6c35c94fcfb415dbe95f408b9ce91ee846ed') => Site
  #  # if given invalid attributes
  #  Site.authenticate('capansis.com', '531e00dac3da5ecf13e8489348e147e430e65bb4') => nil
  def self.authenticate(domain, api_key)
    Site.find_by_domain(domain, :conditions => {:api_key => api_key})
  end
  
  # A convenience method used through the production console to add new Sites.
  #
  #  Site.construct('capansis.com') => A valid site for the given domain
  def self.construct(domain)
    site = self.new
    
    site.domain             = domain.downcase
    site.api_key            = Digest::SHA1.hexdigest(domain + '<salt for api keys>')
    site.email_address      = "authentication@#{domain}"
    site.support_title      = "#{domain} support"
    site.invitation_subject = "you are invited to #{domain}"
    site.activation_subject = "welcome to #{domain}"
    site.recovery_subject   = "reset your password for #{domain}"
    site.invitation_letter  = site.activation_letter = site.recovery_letter = '...'
    
    site.save
    
    return {:domain => site.domain, :api_key => site.api_key}
  end
end
