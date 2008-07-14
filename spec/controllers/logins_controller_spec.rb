require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do
  describe 'the new action' do
    before do
      Account.stub!(:new).and_return(@account = mock_model(Account))
      get :new
    end
        
    it 'should render an xml representation of an account object' do
      # response.should render
    end
  end
end
