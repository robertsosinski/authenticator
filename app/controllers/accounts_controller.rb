# Handles all interaction between a user and the Account model.
class AccountsController < ApplicationController
  # Returns a collection of Accounts.
  def index
    @accounts = Account.find_by_site_id_and_letter(@@site.id, params[:letter])
    respond_to do |format|
      format.html
      format.xml {render :xml => @accounts}  
    end
  end
  
  # Returns the specified Account.
  #
  # API methods:
  #
  # There are two ways to interface with the show action, a get method or a find method.
  #
  #  Account.get(params[:id]) => Hash Table with the specified Account's attributes
  # or
  #  Account.find(params[:id]) => Specified Account
  def show
    begin
    @account = Account.find(params[:id], :conditions => {:site_id => @@site.id})
    respond_to do |format|
      format.html{render :nothing => true}
      format.xml {render :xml => @account}
    end
    rescue ActiveRecord::RecordNotFound
      render :nothing => true, :status => :not_found
    end
  end
  
  # Returns a new Account.
  #
  # API method:
  #
  #  Account.new => New Account
  def new
    @account = Account.new
    respond_to do |format|
      format.html{render :nothing => true}
      format.xml {render :xml => Account.new}
    end
  end
  
  # Creates and returns a new Account.
  #
  # API method:
  #
  #  @account = Account.new(params[:account]) => New Account
  #  # if valid
  #  @account.save => true, and a copy of the compleated Account
  #  # if invalid
  #  @account.save => false, and the errors
  def create
    @account = Account.new(params[:account])
    @account.site = @@site
    if @account.save
      Mailer.deliver_activation(:site => @@site, :account => @account)
      respond_to do |format|
        format.html{render :nothing => true}
        format.xml {render :xml => @account, :status => :created, :location => @account}
      end
    else
      respond_to do |format|
        format.html{render :nothing => true}
        format.xml {render :xml => @account.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  # Activates the specified account.
  def activate
    @account = Account.find(params[:id])
    @account.activate!
  end
  
  # Verifies an Account with a verification link sent to the Account owners email address.
  #
  # API method:
  #
  #  @account.put(:verify, :verification_key => params[:verification_key])
  #
  # If the Account cannot be verified, your application will be returned an ActiveResource::ResourceNotFound error.
  # Just rescue this error as you normally would if this happens.
  #
  # Note, you can check if the Account is being activated or recovered by checking the activated attribute.
  #
  #  # if the verification is for a recovery
  #  @account.activated? => true
  #  # if the verification is for an activation
  #  @account.activated? => false
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
  
  # Returns the specified Account.
  # If using the API, use the the show action through the find or get methods instead.
  def edit
    @account = Account.find(params[:id], :conditions => {:site_id => @@site.id})
    respond_to do |format|
      format.html
      format.xml {render :xml => @account}
    end
  end
  
  # Updates and returns the specified Account.
  #
  # API method:
  #
  #  @account = Account.find(params[:id]).load(params[:account]) => Account loaded with new attributes
  #  # if valid
  #  @account.save => true
  #  # if invalid
  #  @account.save => false
  #
  # Note that the update_attributes method cannot be used, as it is not supported by ActiveResource.
  # Use the load and save method instead.
  def update
    @account = Account.find(params[:id], :conditions => {:site_id => @@site.id})
    if @account.update_attributes(params[:account])
      respond_to do |format|
        format.html do
          flash[:notice] = "Account Updated."
          redirect_to(accounts_path)
        end
        format.xml {render :xml => @account}
      end
    else
      respond_to do |format|
        format.html do
          render(:action => 'edit')
        end
        format.xml {render :xml => @account.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  # Sends a recovery letter to the Account's email address on record with a verification link.
  #
  # API method:
  #
  #  Account.post(:recover, :email_address => params[:email_address])
  #
  # If the email address cannot be found, your application will be returned an ActiveResource::ResourceNotFound error.
  # Just rescue this error as you normally would if this happens.
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
  
  # Bans the specified Account.
  def ban
    @account = Account.find(params[:id])
    @account.ban!
  end
  
  # Unbans the specified Account.
  def unban
    @account = Account.find(params[:id])
    @account.unban!
  end
end
