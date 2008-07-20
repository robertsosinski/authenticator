# Handles all interaction between an application admin and the Site model.
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
