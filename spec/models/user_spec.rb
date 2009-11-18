require 'spec_helper'

describe User do
  def mock_twitter
    Twitter::Base.stub!(:lists)
  end
  
  it "should be valid" do
    User.make
  end
  
  it 'should not be a twitter' do
    User.make.should_not be_twitterer
  end
  
  describe 'with twitter credentials' do
    before :each do
      @user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
    end
    
    it 'should be a twittter' do
      @user.should be_twitterer
    end
    
    it 'should populate tworgy list' do
      @user.should_receive(:twitter).and_return(mock_twitter)
    end
  end
end
