require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic"
    
    Site.should_receive(:authenticate).and_return(@authenticated_site = mock_model(Site))
  end
  
  describe 'the index action' do
    before(:each) do
      Account.stub!(:all).and_return(mock_model(Account))
      
      get :index
    end
    
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the show action' do
    before(:each) do
      Account.stub!(:find).and_return(mock_model(Account))
    end
    
    describe 'in html format' do
      before(:each) do
        get :show, :id => 'id'
      end
      
      it 'should be yield an Unsupported Media Type error' do
        response.should be_unsupported_media_type
      end
    end
    
    describe 'in xml format' do
      before(:each) do
        get :show, :id => 'id', :format => 'xml'
      end
      
      it 'should be successful' do
        response.should be_success
      end
    end
  end
  
  describe 'the create action' do
    describe 'when given valid attributes' do
      before(:each) do
        Account.stub!(:new).and_return(@account = mock_model(Account, :save => true))
        @account.should_receive(:site=).with(@authenticated_site)
        Mailer.should_receive(:deliver_activation).and_return(true)
      end
      
      describe 'in html format' do
        before(:each) do
          post :create
        end
        
        it 'should yield Unsupported Media Type error' do
          response.should be_unsupported_media_type
        end
      end
      
      describe 'in xml format' do
        before(:each) do          
          post :create, :format => 'xml'
        end
        
        it 'should be created' do
          response.should be_created
        end
      end
    end
    
    describe 'when given invalid attributes' do    
      before(:each) do
        Account.stub!(:new).and_return(@account = mock_model(Account, :save => false))
        @account.should_receive(:site=).with(@authenticated_site)
      end
      
      describe 'in html format' do
        before(:each) do
          post :create
        end
        
        it 'should yield Unsupported Media Type error' do
          response.should be_unsupported_media_type
        end
      end
      
      describe 'in xml format' do
        before(:each) do
          post :create, :format => 'xml'
        end
        
        it 'should be unprocessable' do
          response.should be_unprocessable_entity
        end
      end
    end
  end
  
  describe 'the activate action' do
    before(:each) do
      Account.stub!(:find).and_return(@account = mock_model(Account, :activate! => true))
      @account.should_receive(:activate!)
      
      put :activate, :id => 'id', :format => 'js'
    end
    
    it 'should assign @account to the specified Account' do
      assigns[:account].should equal(@account)
    end
    
    it 'should render the activate rjs' do
      response.should render_template(:activate)
    end
  end
  
  describe 'the verify action' do
    describe 'when given a valid id and verification key' do
      before(:each) do
        Account.stub!(:find_by_id_and_verification_key).and_return(@account = mock_model(Account, :activate! => true,
                                                                                                  :is_not_pending_recovery! => true))
      end
      
      describe 'and is an Account pending activation' do
        before(:each) do
          @account.stub!(:is_pending_activation?).and_return(true)
        end
        
        it 'should should activate the account and be successful' do
          @account.should_receive(:activate!)
          
          put :verify, :id => 'id'
          
          response.should be_success
        end
      end
      
      describe 'and is an Account pending recovery' do
        before(:each) do
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
      before(:each) do
        Account.stub!(:find_by_id_and_verification_key).and_return(nil)
        
        put :verify, :id => 'id'
      end
      
      it 'should not be found' do
        response.should be_missing
      end
    end
  end
  
  describe 'the edit action' do
    before(:each) do
      Account.stub!(:find).and_return(@account = mock_model(Account))
    
      get :edit, :id => 'id'
    end
    
    it 'should assign @account to the specified Account' do
      assigns[:account].should equal(@account)
    end
  
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the update action' do
    describe 'when given valid attributes' do
      before(:each) do
        Account.stub!(:find).and_return(@account = mock_model(Account, :update_attributes => true))
      end
      
      describe 'in html format' do
        before(:each) do
          put :update, :id => 'id'
        end

        it 'should assign @account to the specified Account' do
          assigns[:account].should equal(@account)
        end

        it 'should be redirect to the accounts index' do
          response.should redirect_to(accounts_path)
        end
      end
      
      describe 'in xml format' do
        before(:each) do
          put :update, :id => 'id', :format => 'xml'
        end

        it 'should assign @account to the specified Account' do
          assigns[:account].should equal(@account)
        end

        it 'should be success' do
          response.should be_success
        end
      end
    end
    
    describe 'when given invalid attributes' do
      before(:each) do
        Account.stub!(:find).and_return(@account = mock_model(Account, :update_attributes => false))
      end
      
      describe 'in html format' do
        before(:each) do
          put :update, :id => 'id'
        end
        
        it 'should render the new template' do
          response.should render_template(:edit)
        end
      end
      
      describe 'in xml format' do
        before(:each) do
          put :update, :id => 'id', :format => 'xml'
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
  
  describe 'the recover action' do
    describe 'when given a valid email address' do
      before(:each) do
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
      before(:each) do
        Account.stub!(:find_by_email_address).and_return(nil)
        
        post :recover
      end
      
      it 'should not be found' do
        response.should be_missing
      end
    end
  end
  
  describe 'the ban action' do
    before(:each) do
      Account.stub!(:find).and_return(@account = mock_model(Account, :ban! => true))
      @account.should_receive(:ban!)
      
      put :ban, :id => 'id', :format => 'js'
    end
    
    it 'should assign @account to the specified Account' do
      assigns[:account].should equal(@account)
    end
    
    it 'should render the activate rjs' do
      response.should render_template(:ban)
    end
  end
  
  describe 'the unban action' do
    before(:each) do
      Account.stub!(:find).and_return(@account = mock_model(Account, :unban! => true))
      @account.should_receive(:unban!)
      
      put :unban, :id => 'id', :format => 'js'
    end
    
    it 'should assign @account to the specified Account' do
      assigns[:account].should equal(@account)
    end
    
    it 'should render the activate rjs' do
      response.should render_template(:unban)
    end
  end
end
