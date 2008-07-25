require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic"
    
    Site.should_receive(:authenticate).and_return(@authenticated_site = mock_model(Site))
  end
  
  describe 'the create action' do
    describe 'when given valid attributes' do
      before(:each) do
        Login.stub!(:new).and_return(@login = mock_model(Login, :save => true))
        @login.should_receive(:site_id=).with(@authenticated_site.id)
        
        post :create
      end
      
      it 'should assign @login to a Login' do
        assigns[:login].should equal(@login)
      end
      
      it 'should be created' do
        response.should be_created
      end
    end
    
    describe 'when given invalid attributes' do
      before(:each) do
        Login.stub!(:new).and_return(@login = mock_model(Login, :save => false))
        @login.should_receive(:site_id=).with(@authenticated_site.id)
        
        post :create
      end
      
      it 'should assign @login to a Login' do
        assigns[:login].should equal(@login)
      end
      
      it 'should be unprocessable' do
        response.should be_unprocessable_entity
      end
    end
  end
end
