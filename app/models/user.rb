class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :tworgies
  
  before_create :find_screen_name
  after_create :populate_tworgies
  
  def twitterer?
    !(oauth_token.blank? || oauth_secret.blank?)
  end
  
  def twitter
    DBC.require(twitterer?)

    @twitter ||= Twitter::Base.new(oauth)
  end
  
  def populate_tworgies
    if twitterer?
      twitter.lists.lists.each do |list|
        followers_count = twitter.list_members(twitter_username, list.slug).users.length
        following_count = twitter.list_subscribers(twitter_username, list.slug).users.length
        
        tworgies.create :slug => list.slug, :twitter_list_id => list.id, :followers_count => followers_count,
          :following_count => following_count, :uri => list.uri
      end
    end
  end
  
  protected 
  
  def oauth
    DBC.require(twitterer?)

    if @oauth.nil?
      @oauth = Twitter::OAuth.new(APIs[:twitter][:consumer_key], APIs[:twitter][:consumer_secret])
      @oauth.authorize_from_access(oauth_token, oauth_secret)
    end
    
    @oauth
  end
  
  def find_screen_name
    if twitterer?
      self.twitter_username = twitter.verify_credentials.screen_name
    end
  end
end
