require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do  
  it 'should authenticate all API users' do
    ApplicationController.before_filters.should include(:authenticate)
  end
end