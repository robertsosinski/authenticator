require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Login do
  describe 'authenticate_account callback method' do
    describe 'when given valid credentials' do
      before(:each) do
        @login = Login.create({
          :email_address => 'alice@capansis.com',
          :password => 'secret',
          :site_id => sites(:capansis).id
        })
      end
      
      it 'should assign self.match the appropriate account' do
        @login.match.should eql(accounts(:alice))
      end
    end
    
    describe 'when given invalid credentials' do
      before(:each) do
        @login = Login.create({
          :email_address => 'eve@yahoo.com',
          :password => 'invalid',
          :site_id => sites(:capansis).id
        })
      end
      
      it 'should assign self.match to nil' do
        @login.match.should be_nil
      end
    end
  end
  
  describe 'ensure_account_is_not_pending_recovery callback method' do
    describe 'when sent to an account is pending recovery' do
      before(:each) do
        @login = Login.create({
          :email_address => 'casey@capansis.com',
          :password => 'forgot',
          :site_id => sites(:capansis).id
        })
      end
      
      it 'should cancel the recovery' do
        @login.match.is_pending_recovery?.should be_false
      end
    end
  end
end
