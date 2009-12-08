class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :tworgies
  
  before_create :find_screen_name
  after_create :repopulate_tworgies
  
  def twitterer?
    !(oauth_token.blank? || oauth_secret.blank?)
  end
  
  def twitter
    DBC.require(twitterer?)

    @twitter ||= Twitter::Base.new(oauth)
  end
    
  def repopulate_tworgies 
    if twitterer?
      updated_tworgies = []
      
      twitter.lists.lists.each do |list| 
        updated_tworgies << update_or_create_tworgy(list) 
      end
      
      tworgies.each {|t| t.destroy unless updated_tworgies.include?(t) }
    end
  end
  
  private
  
  def update_or_create_tworgy(list)
    DBC.require(twitterer?)
    
    tworgy = tworgies.find_by_twitter_list_id(list.id)
    if !tworgy
      tworgy = tworgies.build :twitter_list_id => list.id
    end

    members_count = twitter.list_members(twitter_username, list.slug).users.length
    subscribers_count = twitter.list_subscribers(twitter_username, list.slug).users.length
    
    tworgy.update_attributes :slug => list.slug, :members_count => members_count,
      :subscribers_count => subscribers_count, :uri => list.uri, :name => list.name

    DBC.ensure(tworgy.valid?)
    tworgy
  end
  
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
