class User < ActiveRecord::Base
  acts_as_authentic
  
  def twitterer?
    !(oauth_token.blank? || oauth_secret.blank?)
  end
  
  def twitter
    DBC.require(twitterer?)

    @twitter ||= Twitter::Base.new(oauth)
  end
  
  protected 
  
  def oauth
    DBC.require(twitterer?)

    if @oauth.nil?
      @oauth ||= Twitter::OAuth.new(APIs[:twitter][:consumer_key], APIs[:twitter][:consumer_secret])
      @oauth.authorize_from_access(oauth_token, oauth_secret)
    end
    
    @oauth
  end
end
