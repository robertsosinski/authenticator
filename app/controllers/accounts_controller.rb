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
  
  def destroy
    Account.destroy(params[:id])
    head :ok
  end
  
  def login
    
  end
end
