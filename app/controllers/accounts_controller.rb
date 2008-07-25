# Handles the interaction between a user and the Account model.  This controller can be interacted with through it's 
# XML based API or it's HTML based administartion panel.
class AccountsController < ApplicationController
  before_filter :authenticate
  
  # Returns a collection of filtered first letter of an accounts email address.
  #
  # API via ActiveResource:
  #
  #  Account.find(:all, :params => {:letter => params[:letter]}) => Collection of Accounts
  def index
    params[:letter] ||= 'a'
    @accounts = Account.find_by_site_id_and_letter(@authenticated_site.id, params[:letter])
    respond_to do |format|
      format.html
      format.xml {render :xml => @accounts}  
    end
  end
  
  # Returns the specified Account.
  #
  # API via ActiveResource:
  #
  #  Account.find(params[:id]) => Specified Account
  def show
    @account = Account.find(params[:id], :conditions => {:site_id => @authenticated_site.id})
    respond_to do |format|
      format.html{head :status => :unsupported_media_type}
      format.xml {render :xml => @account}
    end
  end
  
  # Returns a form to create a new Account.  Used by the admin panel.
  def new
    @account = Account.new
    respond_to do |format|
      format.html
      format.xml {head :unsupported_media_type}
    end
  end
  
  # Creates a new Account and returns it to the user.
  #
  # API via ActiveResource:
  #
  #  @account = Account.new(params[:account]) => New Account
  #
  # NOTE:
  #
  # The create action through the API will create a new, unactivated account and send an activation letter.
  # The create action through the admin panel will create a new activated account and send an invitation letter with the chosen password.
  def create
    @account = Account.new(params[:account])
    @account.site = @authenticated_site
    if @account.save
      respond_to do |format|
        format.html do
          @account.activate!
          Mailer.deliver_invitation(:site => @authenticated_site, :account => @account, :temporary_password => params[:account][:password])
          flash[:notice] = "Invitation sent to #{@account.email_address}."
          redirect_to(new_account_path)
        end
        format.xml do
          Mailer.deliver_activation(:site => @authenticated_site, :account => @account)
          render :xml => @account, :status => :created, :location => @account
        end
      end
    else
      respond_to do |format|
        format.html{render :action => 'new'}
        format.xml {render :xml => @account.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  # Activates the specified account.  Used by the admin panel.
  def activate
    @account = Account.find(params[:id])
    @account.activate!
  end
  
  # Verifies an Account with a verification link sent to the Account owners email address.
  #
  # API via ActiveResource:
  #
  #  @account.put(:verify, :verification_key => params[:verification_key])
  #
  # If the Account cannot be verified, your application will be returned an ActiveResource::ResourceNotFound error.
  # Just rescue this error as you normally would if this happens.
  #
  # Note, you can check if the Account is being activated or recovered by checking the activated attribute.
  #
  #  # If the verification is for an activation
  #  @account.activated? => false
  #  # If the verification is for a recovery
  #  @account.activated? => true
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
  
  # Returns a form to edit the specified Account.  Used by the admin panel.
  def edit
    @account = Account.find(params[:id], :conditions => {:site_id => @authenticated_site.id})
    respond_to do |format|
      format.html
      format.xml {head :unsupported_media_type}
    end
  end
  
  # Updates and returns the specified Account.
  #
  # API via ActiveResource:
  #
  #  @account = Account.find(params[:id]).load(params[:account]) => Account loaded with new attributes
  #  @account.save => Updated Account
  def update
    @account = Account.find(params[:id], :conditions => {:site_id => @authenticated_site.id})
    if @account.update_attributes(params[:account])
      respond_to do |format|
        format.html do
          flash[:notice] = "Account Updated."
          redirect_to(edit_account_path(@account))
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
  # API via ActiveResource:
  #
  #  Account.post(:recover, :email_address => params[:email_address])
  #
  # If the email address cannot be found, your application will be returned an ActiveResource::ResourceNotFound error.
  # Just rescue this error as you normally would if this happens.
  def recover
    account = Account.find_by_email_address(params[:email_address])
    if account
      account.is_pending_recovery!
      Mailer.deliver_recovery(:site => @authenticated_site, :account => account)
      head :ok
    else
      head :not_found
    end
  end
  
  # Bans the specified Account.  Used by the admin panel.
  def ban
    @account = Account.find(params[:id])
    @account.ban!
  end
  
  # Unbans the specified Account.  Used by the admin panel.
  def unban
    @account = Account.find(params[:id])
    @account.unban!
  end
end
