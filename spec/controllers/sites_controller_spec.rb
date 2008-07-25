require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitesController do
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic"
    
    Site.should_receive(:authenticate).and_return(@authenticated_site = mock_model(Site))
  end
  
  describe 'the edit action' do
    before(:each) do
      Site.stub!(:find).and_return(@site = mock_model(Site))
    
      get :edit, :id => 'id'
    end
    
    it 'should assign @site to the specified Site' do
      assigns[:site].should equal(@site)
    end
    
    it 'should be successful' do
      response.should be_success
    end
  end
  
  describe 'the update action' do
    describe 'when given valid attributes' do
      before(:each) do
        Site.stub!(:find).and_return(@site = mock_model(Site, :update_attributes => true))
        
        put :update, :id => 'id'
      end
      
      it 'should redirect back to the accounts index' do
        response.should redirect_to(accounts_path)
      end
    end
    
    describe 'when given invalid attributes' do
      before(:each) do
        Site.stub!(:find).and_return(@site = mock_model(Site, :update_attributes => false))
        
        put :update, :id => 'id'
      end
            
      it 'should assign @site to the specified Site' do
        assigns[:site].should equal(@site)
      end

      it 'should redirect back to the accounts index' do
        response.should render_template(:edit)
      end
    end
  end
end
