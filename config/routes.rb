ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :posts
  map.resources :users
  map.resource :user_session, :except => [:edit, :show, :update]

  map.resources :activities

  map.root :controller => 'home', :action => 'index'
end
