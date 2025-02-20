Rails.application.routes.draw do
  require 'sidekiq/web'
  
  mount Sidekiq::Web => "/sidekiq"

  post "/login", to: "auth#login"
  post "/signup", to: "auth#signup"

  get "/messages/:user_id", to: "messages#index"
  get "/messages", to: "messages#index"
  post "/messages", to: "messages#create"

  get "/metrics", to: "metrics#index"

  # Allow Active Storage direct file access
  resources :messages do
      resources :files, only: [:index, :create, :destroy]
  end
end
