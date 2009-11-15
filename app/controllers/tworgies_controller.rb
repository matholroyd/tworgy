class TworgiesController < ApplicationController
  skip_before_filter :require_user
  before_filter :get_client

  def index
  end
  
  def connect
    request_token = @client.request_token(:oauth_callback => twitter_callback_tworgies_url)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url.sub(/authorize/, 'authenticate')
  end
  
  def twitter_callback
    # Exchange the request token for an access token.
    @access_token = @client.authorize(
      session[:request_token],
      session[:request_token_secret],
      :oauth_verifier => params[:oauth_verifier]
    )
 
    if @client.authorized?
      # Storing the access tokens so we don't have to go back to Twitter again
      # in this session.  In a larger app you would probably persist these details somewhere.
      session[:access_token] = @access_token.token
      session[:secret_token] = @access_token.secret
      session[:user] = true
    end
    
    redirect_to tworgies_path
  end
  
  private
  
  def get_client
    @client = TwitterOAuth::Client.new(
      :consumer_key => APIs[:twitter][:consumer_key],
      :consumer_secret => APIs[:twitter][:consumer_secret] #,
      # :token => session[:access_token],
      # :secret => session[:secret_token] 
    )
    
    @authorized = @client.authorized?
 end
    

end
