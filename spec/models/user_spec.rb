require 'spec_helper'
require 'ostruct'

describe User do
  def mock_twitter
    @mock_twitter ||= mock('twitter', {
      :verify_credentials => mock_verify_credentials,
      :lists => OpenStruct.new(:lists => [1,3,4])
    })
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
  
  describe 'newly created' do
  
    describe 'with twitter credentials' do
      before :each do
        @user = User.make_unsaved(:oauth_token => 'token', :oauth_secret => 'secret')
        @user.stub!(:twitter).and_return(mock_twitter)
        @user.save
      end
    
      it 'should be a twittter' do
        @user.should be_twitterer
      end
    
      it "should populate the user's tworgy list with their twitter list" do
        @user.tworgies.length.should == 3
      end
    end
    
  end
end
