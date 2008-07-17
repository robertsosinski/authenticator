require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do
  describe 'self.authenticate method' do
    describe 'when given valid attributes' do
      it 'should return the requested site' do
        Site.authenticate(sites(:capansis).domain, sites(:capansis).api_key).should eql(sites(:capansis))
      end
    end
    
    describe 'when given invalid attributs' do
      it 'should return nil' do
        Site.authenticate('mallory.com', 'trouble').should be_nil
      end
    end
  end
end
