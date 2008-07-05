class LoginsController < ApplicationController
  def new
    render :xml => Login.new
  end
  
  def create
    @login = Login.new(params[:login])
    if @login.save
      render :xml => @login, :status => :created, :location => ''
    else
      render :xml => @login.errors, :status => :unprocessable_entity
    end
  end
  
  def destroy
    
  end
end
