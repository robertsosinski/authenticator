class LoginsController < ApplicationController  
  def create
    @login = Login.new(params[:login])
    @login.site_id = @@site.id
    if @login.save
      render :xml => @login, :status => :created, :location => @login
    else
      render :xml => @login.errors, :status => :unprocessable_entity
    end
  end
end
