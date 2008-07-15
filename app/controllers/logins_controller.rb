class LoginsController < ApplicationController  
  def create
    @login = Login.new(params[:login])
    if @login.save
      render :xml => @login, :status => :created, :location => @login
    else
      render :xml => @login.errors, :status => :unprocessable_entity
    end
  end
end
