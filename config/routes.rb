Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post :signup
      post :login
      get :me              
      put :profile        
    end
    
    resources :matters
    
    resources :customers do
      resources :matters, controller: 'customer_matters'
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end