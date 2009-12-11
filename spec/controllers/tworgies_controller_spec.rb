require 'spec_helper'

describe TworgiesController do
  before :each do
    @user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
  end

  
  describe 'GET index' do
    it 'should return success' do
      get :index
      response.status.should == '200 OK'
    end
  end
  
  describe 'POST create' do
    before :each do
      UserSession.create(@user)
    end
  
    it 'should return success' do
      post :create, :tworgy => {:name => 'some name'}
      response.status.should == '200 OK'
    end
    
    it 'should create a tworgy' do
      lambda {
        post :create, :tworgy => {:name => 'some name'}
        assigns(:tworgy).errors.count.should == 0
      }.should change(Tworgy, :count).by(1)
    end
    
    it 'should set the name and other attributes correctly' do
      User.twitter.list_create = {:slug => 'aslug', :id => '9876', :uri => 'some uri'}
      post :create, :tworgy => {:name => 'some name'}
      
      tworgy = assigns(:tworgy)
      tworgy.name.should == 'some name'
      tworgy.twitter_list_id.should == 9876
      tworgy.uri.should == 'some uri'
      tworgy.slug.should == 'aslug'
    end
  end
  
end
