class Tworgy < ActiveRecord::Base
  belongs_to :user
  before_create :create_list_on_twitter

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, :scope => :user_id

  attr_accessor :add_yourself, :follow_list
  
  private 
  
  def validate
    errors.add(:user, "must be linked to a twitter account") if user && !user.twitterer?
  end
  
  def create_list_on_twitter
    DBC.require(!user || user.twitterer?)
    
    if twitter_list_id.nil? && user && user.twitterer?
      begin
        list = user.twitter.list_create user.twitter_username, :name => name
        self.slug = list[:slug]
        self.twitter_list_id = list[:id]
        self.uri = list[:uri]
      rescue Exception => e 
        raise
      end
    end
  end
end
