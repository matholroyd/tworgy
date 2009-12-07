require 'spec_helper'

describe Tworgy do
  before(:each) do
    @user = User.make
  end

  it "should have a valid blueprint" do
    Tworgy.make
  end
  
  [:slug, :name, :user_id].each do |field| 
    it "should require #{field}" do
      Tworgy.make_unsaved(field => nil).should have(1).error_on(field)
    end
  end
  
  # [:slug, :name].each do |field| 
  #   it "should have a unique #{field} for that user" do
  #     @user.tworgies.make(field => 'dummy')
  #     @user.tworgies.make_unsaved(field => 'dummy').should have(1).error_on(field)
  #   end
  #   
  #   it "should be fine for other users to have the same #{field}" do
  #     @user.tworgies.make(field => 'dummy')
  #     User.make.tworgies.make(field => 'dummy')
  #   end
  #   
  #   it "should be restricted to 25 chars for #{field}" do
  #     Tworgy.make(field => 'a' * 25)
  #     Tworgy.make_unsaved(field => 'a' * 26).should have(1).error_on(field)
  #   end
  # end
end
