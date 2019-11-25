Rails.application.routes.draw do
  root "missions#index"
  resources :missions
<<<<<<< HEAD
  resources :users, only: [:new, :create]
  resources :workstates, only: [:update]
=======
  resources :workstates, only: [:update]
  resources :users, only: [:new, :create]
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
  resources :sessions, only: [:new, :create, :destroy]
  get "/login", to: "sessions#new", as: "login"
  get "/logout", to: "sessions#destroy", as: "logout"
  get "/search", to: "search#index", as: "search"
  # this route only for testing, will login auto with test account
<<<<<<< HEAD
  get "/test", to: "users#test"

  namespace :admin do
    root "users#index"
    resources :users
    resources :missions
    resources :roles, only: [:update]
    get "/search/:model", to: "search#index", as: "search"
    # this route only for testing, will login auto with admin test account
    get "/test", to: "users#test"
  end

=======
  get "/test", to: "sessions#test"
>>>>>>> 798c040c1e2b52229f11c7a3cb801abd97bfd73e
end
