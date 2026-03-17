Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :customers, only: [] do
        resource :fees, only: %i[show]
        resources :histories, only: %i[index]
        resources :portfolios, only: %i[index show] do
          member do
            get :fees, to: 'fees#show'
            get :history, to: 'histories#show'
            post :deposit
            post :withdraw
            post :transfer
          end
        end
        resource :indicators, only: %i[show]
      end
    end
  end
end
