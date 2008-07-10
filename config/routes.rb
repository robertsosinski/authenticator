ActionController::Routing::Routes.draw do |map|
  map.resources :accounts,
                :collection => {:recover => :post},
                :member => {:verify => :put}
  
  map.resources :logins
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
