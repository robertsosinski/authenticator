class AccountsController < ApplicationController
  def index
    render :xml => Account.all
  end
  
  def show
    render :xml => Account.find(params[:id])
  end
  
  def new
    render :xml => Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.save
      render :xml => @account, :status => :created, :location => @account
    else
      render :xml => @account.errors, :status => :unprocessable_entity
    end
  end
  
  def verify
    if @account = Account.find(params[:id], :conditions => {:verification_key => params[:verification_key]})      
      if @account.is_pending_activation?
        @account.activate_and_clear_verification_key!
      end
      if @account.is_pending_recovery?
        @account.clear_verification_key!
      end
      render :xml => @account, :status => :created, :location => @account
    else
      head :not_found
    end
  end
  
  def edit
    render :xml => Account.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      head :ok
    else
      render :xml => @account.errors, :status => :unprocessable_entity
    end
  end
  
  def recover
    account = Account.find_by_email_address(params[:email_address])
    if account
      account.update_attribute(:verification_key, KeyGenerator.create(64))
      Mailer.deliver_recovery(:verification_key => account.verification_key,
                              :email => account.email_address,
                              :domain => request.env['HTTP_HOST'])
      head :ok
    else
      head :not_found
    end
  end
  
  def destroy
    Account.destroy(params[:id])
    head :ok
  end
end
