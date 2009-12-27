class UserSession < Authlogic::Session::Base
  def self.oauth_consumer
    OAuth::Consumer.new(
      APIs[:twitter][:consumer_key],
      APIs[:twitter][:consumer_secret],
      { :site => APIs[:twitter][:site], :authorize_url => APIs[:twitter][:authenticate_url]}
    )
  end
  
  def after_create 
  end
end  
