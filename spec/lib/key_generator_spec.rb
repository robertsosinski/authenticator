require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyGenerator do
  it 'should return a string of 64 random hexidecimal characters' do
    KeyGenerator.create.length.should eql(64)
  end
  
  it 'should return a string of 32 random hexidecimal characters when given an optional length' do
    KeyGenerator.create(32).length.should eql(32)
  end
end