# Handles all interaction between a user and the Site model.  This controller can only beinteracted with through it's 
# HTML based administartion panel.
class SitesController < ApplicationController
  before_filter :authenticate
  
  # Returns a form to edit the specified Site.  Used by the admin panel.
  def edit
    @site = Site.find(@authenticated_site.id)
  end
  
  # Updates and returns the specified Site.  Used by the admin panel.
  def update
    @site = Site.find(@authenticated_site.id)
    if @site.update_attributes(params[:site])
      flash[:notice] = "Your site options have been updated."
      redirect_to(accounts_path)
    else
      render(:action => 'edit')
    end
  end
end
