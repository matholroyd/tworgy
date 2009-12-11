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
  
  [:name, :user_id].each do |field|  
    it "should require #{field}" do
      @user.tworgies.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
  
  it 'should require name to be unique for that user' do
    @user.tworgies.make(:name => 'a')
    @user.tworgies.make_unsaved(:name => 'a').should have(1).error_on(:name)
    
    Tworgy.make(:name => 'a', :user => User.make(:oauth_token => 'token2', :oauth_secret => 'secret'))
  end
 
  it 'should be linked to a user that is twitterer?' do
    Tworgy.make_unsaved(:user => User.make).should have(1).error_on(:user)
  end

  describe 'twitter interaction' do
    before :each do
      User.twitter.list_create = {:slug => 'aslug', :id => '9876', :uri => 'some uri'}
    end
    
    it 'should get slug and other details from twitter' do
      @tworgy = @user.tworgies.make
      @tworgy.slug.should == 'aslug'
      @tworgy.twitter_list_id.should == 9876
      @tworgy.uri.should == 'some uri'
    end
    
    it 'should not create if problem with contacting twitter' do
      User.twitter.stub!(:list_create).and_return {
        throw Exception.new 
      }
      
      @tworgy = @user.tworgies.make_unsaved
      begin
        @tworgy.save
        fail
      rescue
      end  
      @tworgy.should be_new_record
    end
    
  end
  
end
