ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :tworgies, :collection => {:twitter_callback => :get, :connect => :get, :refresh => :get}
  map.resources :users
  map.resources :posts

  map.controller_actions 'home', %w{testing}

  map.root :controller => 'home', :action => 'index'
end
