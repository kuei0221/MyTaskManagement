Rails.application.routes.draw do
  root "missions#index"
  resources :missions
  resources :workstates, only: [:update]
  resources :users
  resources :sessions
  get "/login", to: "sessions#new", as: "login"
  get "/logout", to: "sessions#destroy", as: "logout"
  get "/search", to: "search#index", as: "search"
end
