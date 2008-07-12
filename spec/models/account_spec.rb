require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  describe 'find_by_email_address_and_password method' do
    describe 'when given valid credentials' do
      before do
        @credentials = {
          :email_address => 'alice@capansis.com',
          :password => 'secret'
        }
      end
      
      it 'should return an Account matching the credentials' do
        Account.find_by_email_address_and_password(@credentials[:email_address], @credentials[:password]).should eql(accounts(:alice))
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
        Account.find_by_email_address_and_password(@credentials[:email_address], @credentials[:password]).should be_nil
      end
    end
  end
  
  describe 'password_is? method' do
    before do
      @account = Account.find(accounts(:alice))
    end
    
    it 'should return true if the correct password is given' do
      @account.password_is?('secret').should be_true
    end
    
    it 'should return false if the correct password is not given' do
      @account.password_is?('incorrect').should be_false
    end
  end
  
  describe 'is_pending_activation? method' do
    describe 'on an account pending activation' do
      before do
        @account = Account.find(accounts(:bob))
      end
    
      it 'should return true' do
        @account.is_pending_activation?.should be_true
      end
    end
    
    describe 'on an account not pending activation' do
      before do
        @account = Account.find(accounts(:alice))
      end
      
      it 'should return false' do
        @account.is_pending_activation?.should be_false
      end
    end
  end
  
  describe 'activate! method' do
    before do
      @account = Account.find(accounts(:bob))
    end
    
    it 'should set the activated attribute to true' do
      @account.activated?.should be_false
      @account.activate!
      @account.activated?.should be_true
    end
  end
  
  describe 'is_pending_recovery? method' do
    describe 'on an account pending recovery' do
      before do
        @account = Account.find(accounts(:casey))
      end
    
      it 'should return true' do
        @account.is_pending_recovery?.should be_true
      end
    end
    
    describe 'on an account not pending recovery' do
      before do
        @account = Account.find(accounts(:alice))
      end
      
      it 'should return false' do
        @account.is_pending_recovery?.should be_false
      end
    end
  end
  
  describe 'is_pending_recovery! method' do
    before do
      @account = Account.find(accounts(:alice))
    end
    
    it 'should set an account account as pending recovery' do
      @account.is_pending_recovery?.should be_false
      @account.is_pending_recovery!
      @account.is_pending_recovery?.should be_true
    end
  end
  
  describe 'is_not_pending_recovery! method' do
    before do
      @account = Account.find(accounts(:casey))
    end
    
    it 'should set an account as not pending recovery' do
      @account.is_pending_recovery?.should be_true
      @account.is_not_pending_recovery!
      @account.is_pending_recovery?.should be_false
    end
  end
  
  describe 'ban! method' do
    before do
      @account = Account.find(accounts(:alice))
    end
    
    it 'should set the banned attribute to true' do
      @account.banned?.should be_false
      @account.ban!
      @account.banned?.should be_true
    end
  end
  
  describe 'unban! method' do
    before do
      @account = Account.find(accounts(:mallory))
    end
    
    it 'should set the banned attribute to false' do
      @account.banned?.should be_true
      @account.unban!
      @account.banned?.should be_false
    end
  end
  
  describe 'when created' do
    describe 'with valid credentials' do
      before do
        @account = Account.create({
          :email_address => 'dave@capansis.com',
          :password => 'password',
          :password_confirmation => 'password'
        })
      end
      
      it 'should be saved' do
        @account.valid?.should be_true
        @account.new_record?.should be_false
      end
      
      it 'should flush plain text passwords' do
        @account.password.should be_nil
        @account.password_confirmation.should be_nil
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
        @account.valid?.should_not be_true
        @account.new_record?.should be_true
      end
            
      it 'should yield errors' do
        @account.errors.on(:email_address).should eql('must be valid (e.g. name@domain.com)')
        @account.errors.on(:password).should include('must be six or more characters')
        @account.errors.on(:password).should include('must match Password Confirmation')
      end
      
      it 'should flush plain text passwords' do
        @account.password.should be_nil
        @account.password_confirmation.should be_nil
      end
    end
    
    describe 'without a unique email address' do
      before do
        @account = Account.create({
          :email_address => 'alice@capansis.com',
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
      
      it 'should flush plain text passwords' do
        @account.password.should be_nil
        @account.password_confirmation.should be_nil
      end
    end
    
    describe 'without a password' do
      before do
        @account = Account.create({
          :email_address => 'new.user@capansis.com',
          :password => nil,
          :password_confirmation => nil
        })
      end
      
      it 'should be marked as invalid and not saved' do
        @account.valid?.should be_false
        @account.new_record?.should be_true
      end
      
      it 'should yield errors' do
        @account.errors.on(:password).should eql('must be six or more characters')
      end
      
      it 'should flush plain text passwords' do
        @account.password.should be_nil
        @account.password_confirmation.should be_nil
      end
    end
    
    describe 'with a blank password' do
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
      
      it 'should flush plain text passwords' do
        @account.password.should be_nil
        @account.password_confirmation.should be_nil
      end
    end
  end
  
  describe 'when updated' do
    describe 'with a new password' do
      before do
        @account = Account.find(accounts(:alice))
        @account.update_attributes({
          :password => 'changing',
          :password_confirmation => 'changing'
        })
      end
      
      it 'should update the salt and encrypted_pasword attributes' do
        @account.salt.should_not eql(accounts(:alice).salt)
        @account.encrypted_password.should_not eql(accounts(:alice).encrypted_password)
      end
    end
    
    describe 'without a new password' do
      before do
        @account = Account.find(accounts(:alice))
        @account.update_attributes({
          :email_address => 'changed@capansis.com',
          :password => nil,
          :password_confirmation => nil
        })
      end
      
      it 'should change the email_address' do
        @account.email_address.should eql('changed@capansis.com')
      end
      
      it 'should not update the salt or encrypted_password attributes' do
        @account.salt.should eql(accounts(:alice).salt)
        @account.encrypted_password.should eql(accounts(:alice).encrypted_password)
      end
    end
    
    describe 'with a blank password' do
      before do
        @account = Account.find(accounts(:alice))
        @account.update_attributes({
          :email_address => 'changed@capansis.com',
          :password => '',
          :password_confirmation => ''
        })
      end
      
      it 'should change the email_address' do
        @account.email_address.should eql('changed@capansis.com')
      end
      
      it 'should not update the salt or encrypted_password attributes' do
        @account.salt.should eql(accounts(:alice).salt)
        @account.encrypted_password.should eql(accounts(:alice).encrypted_password)
      end
    end
  end
end
