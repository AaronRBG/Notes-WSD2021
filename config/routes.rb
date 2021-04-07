Rails.application.routes.draw do
  resources :sessions
  resources :notes
  resources :user
  root "sessions#index"  
end