require 'spec_helper'

describe User do
  
  it "should be valid" do
    User.make
  end
  
  it 'should not be a twitter' do
    User.make.should_not be_twitterer
  end

  it 'should make a valid twitter' do
    user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
    user.should be_valid
    user.should be_twitterer
  end
  
  describe 'with twitter credentials' do
    before :each do
      @user = User.make_unsaved(:oauth_token => 'token', :oauth_secret => 'secret')
      User.twitter.lists.lists = [
            {:slug => 'listA', :id => 1, :name =>'listA'},
            {:slug => 'listB', :id => 2, :name =>'listB'}
          ].ostructify
      @user.save
    end

    describe 'newly created' do
    
      it 'should be a twittter' do
        @user.should be_twitterer
      end
    
      it "should populate the user's tworgy list with their twitter list" do
        @user.tworgies.length.should == 2
      end
      
      it "should populate the user's tworgy lists with the data from twitter" do
        @user.tworgies[0].slug.should == 'listA'
        @user.tworgies[0].twitter_list_id.should == 1

        @user.tworgies[1].slug.should == 'listB'
        @user.tworgies[1].twitter_list_id.should == 2
      end

    end
    
    describe '#repopulate_tworgies' do
      
      it "should repopulate the user's tworgy list" do
        @user.tworgies.length.should == 2
        
        @user.stub!(:twitter).and_return(mock_twitter({
          :lists => {:lists => [{:slug => 'listA', :id => 1, :name =>'listA'}]}
        }))
        
        @user.repopulate_tworgies
        @user.reload
        @user.tworgies.length.should == 1
      end      
      
      it 'should not overwrite an existing one if the list id matches' do
        tworgy = @user.tworgies.first
        @user.repopulate_tworgies
        @user.reload
        @user.tworgies.first.should == tworgy
      end
    end
    
  end
end
