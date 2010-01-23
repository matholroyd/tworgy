require RAILS_ROOT + '/spec/blueprints'

User.transaction do
  20.times do 
    user = User.make(:oauth_token => "token_#{rand}", :oauth_secret => 'secret')
    10.times { user.tworgies.make }
  end
end