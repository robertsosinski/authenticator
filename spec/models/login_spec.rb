require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Login do
  before(:each) do
    @login = Login.new
  end

  it "should be valid" do
    @login.should be_valid
  end
end
