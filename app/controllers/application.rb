# Authenticates the service through HTTP Authentication Basic and filters passwords from the logs.
# NOTE: Forgery protection is turned off in order to allow other non-Rails applications to interact via the API.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  before_filter :authenticate
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'bd5a91caae4a988a081624b70159ea0a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  protected
  
  # Authenticates the API and admin panel.
  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
      @@site = Site.authenticate(user, password)
      @authenticated_site = @@site
    end
  end
end
