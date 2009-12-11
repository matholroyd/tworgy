class Tworgy < ActiveRecord::Base
  belongs_to :user
  before_create :create_list_on_twitter
  validates_presence_of :name, :user_id
  
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
      rescue Exception => e 
        throw e
      end
    end
  end
end
