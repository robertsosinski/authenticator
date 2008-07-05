ActionController::Routing::Routes.draw do |map|
  map.resources :accounts
  map.resources :logins
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
