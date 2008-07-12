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
      Mailer.deliver_activation(:verification_key => @account.verification_key,
                                :email => @account.email_address,
                                :domain => request.env['HTTP_HOST'])
      
      render :xml => @account, :status => :created, :location => @account
    else
      render :xml => @account.errors, :status => :unprocessable_entity
    end
  end
  
  def verify
    account = Account.find_by_id_and_verification_key(params[:id], params[:verification_key])
    if account
      if account.is_pending_activation?
        account.activate!
      else # account is pending recovery
        account.is_not_pending_recovery!
      end
      head :ok
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
      account.create_verification_key!
      Mailer.deliver_recovery(:verification_key => account.verification_key,
                              :email => account.email_address,
                              :domain => request.env['HTTP_HOST'])
      head :ok
    else
      head :not_found
    end
  end
end
