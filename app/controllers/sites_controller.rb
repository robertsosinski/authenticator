# Handles all interaction between a user and the Site model.  This controller can be interacted with through it's 
# HTML based administartion panel, which is secured using HTTP Basic Authentication.
class SitesController < ApplicationController
  # Returns the specified Site.
  def edit
    @site = Site.find(@@site.id)
  end
  
  # Updates and returns the specified Site.
  def update
    @site = Site.find(@@site.id)
    if @site.update_attributes(params[:site])
      flash[:notice] = "Your site options have been updated"
      redirect_to(accounts_path)
    else
      render(:action => 'edit')
    end
  end
end
