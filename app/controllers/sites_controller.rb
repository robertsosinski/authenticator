class SitesController < ApplicationController
  def edit
    @site = Site.find(@@site.id)
  end
  
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
