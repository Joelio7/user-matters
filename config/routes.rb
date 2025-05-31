Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post :signup
      post :login
      get :me
    end
    
    resources :users
    resources :matters
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end