ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'accounts', :action => 'index'
  
  map.resources :accounts,
                :collection => {:recover => :post},
                :member => {:activate => :put, :verify => :put, :ban => :put, :unban => :put}
  
  map.resources :logins
  
  map.resources :sites
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
