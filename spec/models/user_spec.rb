require 'spec_helper'

describe User do
  def mock_twitter
    @mock_twitter ||= mock('twitter', {:verify_credentials => mock_verify_credentials})
  end
  
  def mock_verify_credentials
    @mock_verify_credentials ||= mock('verify_credentials', {:screen_name => 'bob'})
  end
  
  it "should be valid" do
    User.make
  end
  
  it 'should not be a twitter' do
    User.make.should_not be_twitterer
  end
  
  describe 'with twitter credentials' do
    before :each do
      @user = User.make_unsaved(:oauth_token => 'token', :oauth_secret => 'secret')
      @user.stub!(:twitter).and_return(mock_twitter)
    end
    
    it 'should be a twittter' do
      @user.should be_twitterer
    end
    
    it 'should populate tworgy list' do
      # @user.should_receive(:twitter).and_return(mock_twitter)
    end
  end
end
