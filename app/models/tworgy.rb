class Tworgy < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :slug, :user_id
end
