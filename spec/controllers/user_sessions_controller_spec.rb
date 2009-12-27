require 'spec_helper'

describe UserSessionsController do

  before :each do
    @user = User.make(:oauth_token => 'token', :oauth_secret => 'secret')
  end

  describe 'POST create' do
    it 'should repopulate the users twitter lists' do
      # post :create, 
    end
  end
  
end
