class Tworgy < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :slug, :user_id
  # validates_uniqueness_of :slug, :name, :scope => [:user_id]
  # validates_length_of :name, :slug, :maximum => 25
end
