require 'spec_helper'

describe User do
  it "should be valid" do
    User.make
  end
  
  it 'should not be a twitter' do
    User.make.should_not be_twitterer
  end
  
  describe 'with twitter credentials' do
    it 'should be a twittter' do
      User.make(:oauth_token => 'token', :oauth_secret => 'secret').should be_twitterer
    end
  end
end
