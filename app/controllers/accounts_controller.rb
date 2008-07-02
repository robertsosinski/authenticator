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
      render :xml => @account, :status => :created, :location => 'hello world'
    else
      render :xml => @account.errors, :status => :unprocessable_entity
    end
  end
  
  def edit
    render :xml => Account.find(params[:id])
  end
  
  def update
    
  end
  
  def destroy
    
  end
end
