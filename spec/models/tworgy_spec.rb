require 'spec_helper'

describe Tworgy do
  before(:each) do
    @user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
  end

  it "should have a valid blueprint" do
    @user.tworgies.make.should be_valid
  end
  
  it 'should be ok to call make_unsaved' do
    @user.tworgies.make_unsaved.should be_valid
  end
  
  [:name].each do |field|  
    it "should require #{field}" do
      @user.tworgies.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
  
  it 'should require user' do
    Tworgy.make_unsaved(:user => nil).should have(1).error_on(:user_id)
  end
 
  it 'should be linked to a user that is twitterer?' do
    Tworgy.make_unsaved(:user => User.make).should have(1).error_on(:user)
  end

  describe 'twitter interaction' do
    before :each do
      User.twitter.list_create = {:slug => 'aslug'}
      @tworgy = @user.tworgies.make
    end
    
    it 'should get slug and other details from twitter' do
      @tworgy.slug.should == 'aslug'
    end
    
  end
  
end
