require 'spec_helper'

describe TworgiesController do
  before :each do
    @user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
  end

  
  describe 'GET index' do
    describe 'with twitterer' do
      it 'should return success' do
        get :index
        response.status.should == '200 OK'
      end
      
      it 'should set @tworgy' do
        get :index
        assigns(:tworgy).should_not be_nil
      end
    end
    
  end
  
  describe 'POST create' do
    describe 'with twitterer' do
      before :each do
        UserSession.create(@user)
      end
  
      it 'should return success' do
        post :create, :tworgy => {:name => 'some name'}
        response.should redirect_to(tworgies_path)
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

    describe 'with non-twitterer user' do
      before :each do
        @user = User.make
        UserSession.create(@user)
      end

      it 'should redirect' do
        post :create, :tworgy => {:name => 'some'}
        response.should redirect_to(tworgies_path)
      end
    end
    
  end
  
  describe 'put update' do
    describe 'with twitter user' do
      before :each do
        @tworgy = @user.tworgies.make
        UserSession.create(@user)
      end

      it 'should return index' do
        put :update, :id => @tworgy.id, :tworgy => {:name => 'some name'}
        response.should redirect_to(tworgies_path)
      end

      it 'should update a tworgy' do
        put :update, :id => @tworgy.id, :tworgy => {:name => 'some name'}
        assigns(:tworgy).name.should == 'some name'
      end
      
    end
    
    describe 'without a twitter user' do
      before :each do
        @user = User.make
        UserSession.create(@user)
      end

      it 'should redirect' do
        put :update, :id => 1, :tworgy => {:name => 'some'}
        response.should redirect_to(tworgies_path)
      end
    end

  end
  
end
