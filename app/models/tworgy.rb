class Tworgy < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :slug, :user_id
  validates_uniqueness_of :slug, :context => [:user_id]
end
