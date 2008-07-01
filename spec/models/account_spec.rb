require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  describe 'find_by_credentials method' do
    describe 'when given valid credentials' do
      before do
        @credentials = {
          :email_address => 'robert@capansis.com',
          :password => 'beast'
        }
      end
      
      it 'should return an Account matching the credentials' do
        Account.find_by_credentials(@credentials).should eql(accounts(:robert))
      end
    end
    
    describe 'when given invalid credentials' do
      before do
        @credentials = {
          :email_address => 'mallory@capansis.com',
          :password => 'invalid'
        }
      end
      
      it 'should return nil' do
        Account.find_by_credentials(@credentials).should be_nil
      end
    end
  end
  
  describe 'verify_password method' do
    before do
      @account = Account.find(accounts(:robert))
    end
    
    it 'should return true if the correct password is given' do
      @account.verify_password('beast').should be_true
    end
    
    it 'should return false if the correct password is not given' do
      @account.verify_password('incorrect').should be_false
    end
  end
  
  describe 'when created' do
    describe 'with valid credentials' do
      before do
        @account = Account.create({
          :email_address => 'new.user@capansis.com',
          :password => 'secret',
          :password_confirmation => 'secret'
        })
      end
      
      it 'should be marked as valid and saved' do
        @account.valid?.should be_true
        @account.new_record?.should be_false
      end
    end
    
    describe 'with invalid credentials' do
      before do
        @account = Account.create({
          :email_address => 'not an email address',
          :password => 'short',
          :password_confirmation => 'different'
        })
      end
      
      it 'should be marked as invalid and not saved' do
        @account.valid?.should be_false
        @account.new_record?.should be_true
      end
            
      it 'should yield errors' do
        @account.errors.on(:email_address).should eql('must be valid (e.g. name@domain.com)')
        @account.errors.on(:password).should include('must be six or more characters')
        @account.errors.on(:password).should include('must match Password Confirmation')
      end
    end
    
    describe 'without a unique email address' do
      before do
        @account = Account.create({
          :email_address => 'robert@capansis.com',
          :password => 'secret',
          :password_confirmation => 'secret'
        })
      end
      
      it 'should be marked as invalid and not saved' do
        @account.valid?.should be_false
        @account.new_record?.should be_true
      end
      
      it 'should yield errors' do
        @account.errors.on(:email_address).should eql('must be unique')
      end
    end
    
    describe 'without a password' do
      before do
        @account = Account.create({
          :email_address => 'new.user@capansis.com',
          :password => '',
          :password_confirmation => ''
        })
      end
      
      it 'should be marked as invalid and not saved' do
        @account.valid?.should be_false
        @account.new_record?.should be_true
      end
      
      it 'should yield errors' do
        @account.errors.on(:password).should eql('must be six or more characters')
      end
    end
  end
  
  describe 'when updated' do
    describe 'with a new password' do
      before do
        @account = Account.find(accounts(:robert))
        @account.update_attributes({
          :password => 'changing',
          :password_confirmation => 'changing'
        })
      end
      
      it 'should update the salt and encrypted_pasword attributes' do
        @account.salt.should_not eql(accounts(:robert).salt)
        @account.encrypted_password.should_not eql(accounts(:robert).encrypted_password)
      end
    end
    
    describe 'without a new password' do
      before do
        @account = Account.find(accounts(:robert))
        @account.update_attributes({
          :password => '',
          :password_confirmation => ''
        })
      end
      
      it 'should not update the salt or encrypted_password attributes' do
        @account.salt.should eql(accounts(:robert).salt)
        @account.encrypted_password.should eql(accounts(:robert).encrypted_password)
      end
    end
  end
end
