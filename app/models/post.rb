class Post < ActiveRecord::Base
  validates_presence_of :title, :fictional, :factual
end
