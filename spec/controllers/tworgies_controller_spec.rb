require 'spec_helper'

describe TworgiesController do
  before :each do
    @user = User.make
  end

  
  describe 'GET index' do
    it 'should return success' do
      get :index
      response.status.should == '200 OK'
    end
  end
  
  # describe 'POST create' do
  #   before :each do
  #     UserSession.create(@user)
  #   end
  # 
  #   it 'should return success' do
  #     post :create, :tworgy => {:name => 'some name'}
  #     response.status.should == '200 OK'
  #   end
  #   
  #   it 'should create a tworgy' do
  #     lambda {
  #       post :create, :tworgy => {:name => 'some name'}
  #       assigns(:tworgy).errors.count.should == 0
  #     }.should change(Tworgy, :count).by(1)
  #   end
  #   
  #   it 'should create '
  # end
  
end
