Rails.application.routes.draw do
  root "missions#index"
  resources :missions
  resources :workstates, only: [:update]
  get "/search", to: "search#index", as: "search"
  get "/sort", to: "sorts#index", as: "sort"
end
