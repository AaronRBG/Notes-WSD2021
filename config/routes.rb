Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes

  delete 'logout' => "sessions#logout"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'


root "sessions#new"  
end