require 'spec_helper'

describe Tworgy do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :slug => "value for slug",
      :twitter_list_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Tworgy.create!(@valid_attributes)
  end
end
