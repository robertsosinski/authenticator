# Handles all interaction between a user and the Login model.  This controller can only be interacted with through it's 
# XML based API.
class LoginsController < ApplicationController    
  before_filter :authenticate
  
  # before_filter :authenticate
  
  # Creates and returns a new Login object.
  #
  # API via ActiveResource:
  #
  #  @login = Login.new(params[:account]) => New Login or Validation Errors
  def create
    @login = Login.new(params[:login])
    @login.site_id = @authenticated_site.id
    if @login.save
      render :xml => @login, :status => :created, :location => @login
    else
      render :xml => @login.errors, :status => :unprocessable_entity
    end
  end
end
