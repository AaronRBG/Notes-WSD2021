Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes

  get "logout" => "sessions#logout", :as => "logout"
  get "login" => "sessions#login", :as => "login"
  post "login" => "sessions#index"

root "sessions#new"  

##root "users#index" 


end