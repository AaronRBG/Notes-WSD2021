Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes
  root "sessions#index"  
end