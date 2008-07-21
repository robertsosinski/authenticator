# Handles all interaction between a user and the Login model.  This controller can only be interacted with through it's 
# XML based API.
class LoginsController < ApplicationController  
  # Creates and returns a new Login object.
  #
  # API method:
  #
  #  @login = Login.new(params[:account]) => New Login
  #  # if valid
  #  @login.save => "true" and a copy of the compleated login
  #  # if invalid
  #  @login.save => "false" and the errors
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
