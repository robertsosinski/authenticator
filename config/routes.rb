ActionController::Routing::Routes.draw do |map|
  map.resources :accounts,
                :collection => {:recover => :post},
                :member => {:activate => :put, :verify => :put, :ban => :put, :unban => :put}
  
  map.resources :logins
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
