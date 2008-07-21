require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') and include ApplicationHelper

describe ApplicationHelper do
  describe 'the letter_options helper' do
    it 'should return an array of letters from a to z beginning with #' do
      letter_options.should eql(('a'..'z').to_a.unshift('#'))
    end
  end
  
  describe 'the hide_flash helper' do
    it 'should return the prototype to hide the flash div' do
      hide_flash.should eql('$("flash").hide();')
    end
  end
end
