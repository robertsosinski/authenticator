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
      before do
        Account.stub!(:find_by_id_and_verification_key).and_return(@account = mock_model(Account, :activate! => true,
                                                                                                  :is_not_pending_recovery! => true))
      end
      
      describe 'and is an Account pending activation' do
        before do
          @account.stub!(:is_pending_activation?).and_return(true)
        end
        
        it 'should should activate the account and be successful' do
          @account.should_receive(:activate!)
          
          put :verify, :id => 'id'
          
          response.should be_success
        end
      end
      
      describe 'and is an Account pending recovery' do
        before do
          @account.stub!(:is_pending_activation?).and_return(false)
        end
        
        it 'should should activate the account and be successful' do
          @account.should_receive(:is_not_pending_recovery!)
          
          put :verify, :id => 'id'
          
          response.should be_success
        end
      end
    end
    
    describe 'when given an invalid id or verification key' do
      before do
        Account.stub!(:find_by_id_and_verification_key).and_return(nil)
        
        put :verify, :id => 'id'
      end
      
      it 'should not be found' do
        response.should be_missing
      end
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
      
      it 'should be success' do
        response.should be_success
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
  
  describe 'the recover action' do
    describe 'when given a valid email address' do
      before do
        Account.stub!(:find_by_email_address).and_return(@account = mock_model(Account, :save => true,
                                                                                        :verification_key => 'value',
                                                                                        :email_address => 'value'))                                                                      
        @account.should_receive(:is_pending_recovery!).and_return(true)
        Mailer.should_receive(:deliver_recovery).and_return(true)
        
        post :recover
      end
      
      it 'should be created' do
        response.should be_success
      end
    end
    
    describe 'when given an invalid email address' do
      before do
        Account.stub!(:find_by_email_address).and_return(nil)
        
        post :recover
      end
      
      it 'should not be found' do
        response.should be_missing
      end
    end
  end
end
