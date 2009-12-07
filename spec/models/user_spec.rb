require 'spec_helper'

describe User do
  def mock_twitter
    @mock_twitter ||= {
      :verify_credentials => mock_verify_credentials,
      :lists => {:lists => [
        {:slug => 'listA', :id => '123'},
        {:slug => 'listB', :id => '124'}
      ]},
      :list_members => {:users => {:length => 10}},
      :list_subscribers => {:users => {:length => 10}}
    }.ostructify
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
        @user.tworgies.length.should == 2
      end
      
      it "should populate the user's tworgy lists with the data from twitter" do
        @user.tworgies[0].slug.should == 'listA'
      end
      
      it "should repopulate the user's tworgy list" do
        # pending
      end
    end
    
  end
end
