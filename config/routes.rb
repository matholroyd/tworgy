ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :user_session, :except => [:edit, :show, :update]
end
