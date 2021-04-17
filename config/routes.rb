Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes

  get 'logout' => "sessions#logout", :as => "logout"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

root "sessions#new"  

##root "users#index" 


end