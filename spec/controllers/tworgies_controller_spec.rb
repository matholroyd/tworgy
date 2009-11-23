require 'spec_helper'

describe TworgiesController do
  
  describe 'GET index' do
    it 'should return success' do
      get :index
      response.status.should == '200 OK'
    end
  end
  
end
