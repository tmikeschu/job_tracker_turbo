Rails.application.routes.draw do
  root to: "home#show"

  resources :users, only: [:new, :create]
  get "/dashboard", to: "users#show"
  get "/login", to: "sessions#new"
end
