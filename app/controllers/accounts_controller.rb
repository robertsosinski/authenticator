class AccountsController < ApplicationController
  def index
    render :xml => Account.all(:conditions => {:site_id => @@site.id})
  end
  
  def show
    render :xml => Account.find(params[:id], :conditions => {:site_id => @@site.id})
  end
  
  def new
    render :xml => Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    @account.site = @@site
    if @account.save
      Mailer.deliver_activation(:site => @@site, :account => @account)
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
      else
        account.is_not_pending_recovery!
      end
      head :ok
    else
      head :not_found
    end
  end
  
  def edit
    render :xml => Account.find(params[:id], :conditions => {:site_id => @@site.id})
  end
  
  def update
    @account = Account.find(params[:id], :conditions => {:site_id => @@site.id})
    if @account.update_attributes(params[:account])
      render :xml => @account, :status => :ok
    else
      render :xml => @account.errors, :status => :unprocessable_entity
    end
  end
  
  def recover
    account = Account.find_by_email_address(params[:email_address])
    if account
      account.is_pending_recovery!
      Mailer.deliver_recovery(:site => @@site, :account => account)
      head :ok
    else
      head :not_found
    end
  end
end
