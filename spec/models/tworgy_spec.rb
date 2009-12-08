require 'spec_helper'

describe Tworgy do

  before(:each) do
    @user = User.make
    @user.stub!(:twitter).and_return(mock_twitter)
  end

  it "should have a valid blueprint" do
    Tworgy.make
  end
  
  [:slug, :name, :user_id].each do |field|  
    it "should require #{field}" do
      Tworgy.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end

  it 'should be accepted by twitter' do
    
  end
  
end
