Rails.application.routes.draw do
  resources :sessions
  resources :notes
  root "sessions#index"  
end