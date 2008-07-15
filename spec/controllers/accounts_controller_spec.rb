require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  describe 'the index action' do
    before do
      Account.stub!(:all).and_return(mock_model(Account))
      
      get :index
    end
    
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the show action' do
    before do
      Account.stub!(:find).and_return(mock_model(Account))
      
      get :show, :id => 'id'
    end
    
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the new action' do
    before do
      Account.stub!(:new).and_return(mock_model(Account))
      
      get :new
    end
    
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the create action' do
    describe 'when given valid attributes' do
      before do
        Account.stub!(:new).and_return(@account = mock_model(Account, :save => true,
                                                                      :verification_key => 'value',
                                                                      :email_address => 'value'))
        Mailer.should_receive(:deliver_activation).and_return(true)
        
        post :create
      end
      
      it 'should be created' do
        response.should be_created
      end
    end
    
    describe 'when given invalid attributes' do
      before do
        Account.stub!(:new).and_return(@account = mock_model(Account, :save => false))
        Mailer.should_not_receive(:deliver_activation)
        
        post :create
      end
      
      it 'should unprocessable' do
        response.should be_unprocessable_entity
      end
    end
  end
  
  describe 'the verify action' do
    describe 'when given a valid id and verification key' do
      describe 'and is an Account pending activation' do
        
      end
      
      describe 'and is an Account pending recovery' do
        
      end
    end
    
    describe 'when given an invalid id or verification key' do
      
    end
  end
  
  describe 'the edit action' do
    before do
      Account.stub!(:find).and_return(mock_model(Account))
      
      get :edit, :id => 'id'
    end
    
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the update action' do
    describe 'when given valid attributes' do
      before do
        Account.stub!(:find).and_return(@account = mock_model(Account, :update_attributes => true))
      
        put :update, :id => 'id'
      end
      
      it 'should assign @account to the specified Account' do
        assigns[:account].should equal(@account)
      end
      
      it 'should be accepted' do
        response.should be_accepted
      end
    end
    
    describe 'when given invalid attributes' do
      before do
        Account.stub!(:find).and_return(@account = mock_model(Account, :update_attributes => false))

        put :update, :id => 'id'
      end
      
      it 'should assign @account to the specified Account' do
        assigns[:account].should equal(@account)
      end
      
      it 'should be unprocessable' do
        response.should be_unprocessable_entity
      end
    end
  end
end
