ActionController::Routing::Routes.draw do |map|
  map.resource :user_session, :except => [:edit, :show, :update]
  map.resources :tworgies, :collection => {:twitter_callback => :get, :connect => :get}
  map.resources :users
  map.resources :posts
  map.resources :activities

  map.root :controller => 'home', :action => 'index'
end
