Rails.application.routes.draw do
  root "missions#index"
  resources :missions
  resources :workstates, only: [:update]
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  namespace :admin do
    root "users#index"
    resources :users
    resources :missions
    resources :roles, only: [:update]
    get "/search/:model", to: "search#index", as: "search"
  end
  get "/login", to: "sessions#new", as: "login"
  get "/logout", to: "sessions#destroy", as: "logout"
  get "/search", to: "search#index", as: "search"
  # this route only for testing, will login auto with test account
  get "/test", to: "sessions#test"
end
