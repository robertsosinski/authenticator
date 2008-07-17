require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do
  before do
    controller.stub!(:authenticate).and_return(true)
  end
  
  describe 'the create action' do
    describe 'when given valid attributes' do
      before do
        Login.stub!(:new).and_return(@login = mock_model(Login, :save => true))
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
      before do
        Login.stub!(:new).and_return(@login = mock_model(Login, :save => false))
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
