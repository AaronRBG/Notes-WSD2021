Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes

  get "logout" => "sessions#logout", :as => "logout"
  get "login" => "sessions#index", :as => "login"
  post "login" => "sessions#login"

  root "sessions#new"  


end