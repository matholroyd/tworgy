require 'spec_helper'

describe TworgiesController do
  integrate_views
  
  before :each do
    @user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
    @user_other = User.make(:oauth_token => 'token2', :oauth_secret => 'secret')
  end
  
  describe 'GET index' do
    it 'should return success if not logged in' do
      get :index
      response.status.should == '200 OK'
    end

    it 'should return success if logged in' do
      UserSession.create(@user)
      get :index
      response.status.should == '200 OK'
    end

    describe 'JSON' do
      it 'should return success' do
        get :index, :format => 'json'
        response.status.should == '200 OK'
      end

      it 'should return all tworgies' do
        get :index, :format => 'json'
        assigns(:tworgies).should == Tworgy.all 
      end
      
      it 'should only return the users tworgies' do
        @user.tworgies(true).count.should == 2
        @user_other.tworgies(true).count.should == 2
        
        UserSession.create(@user)
        get :index, :current_user_only => true, :format => 'json'
        assigns(:tworgies).should == @user.tworgies
      end
    end
  end
  
  describe 'GET refresh' do
    describe 'with twitterer' do
      before :each do
        @user.tworgies.destroy_all
        UserSession.create(@user)
      end
      
      it 'should redirect to index' do
        get :refresh
        response.should redirect_to(tworgies_path)
      end
      
      it 'should refresh the tworgy list' do
        @user.tworgies.length.should == 0
        get :refresh
        @user.tworgies(true).length.should == 2
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
      
      it 'should render index if problem' do
        post :create
        response.should render_template('index')
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
