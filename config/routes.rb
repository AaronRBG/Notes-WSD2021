Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes

  delete 'logout' => "sessions#logout"
  delete 'destroy_user' => "users#destroy"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'promote', to: 'users#promote'
  post 'demote', to: 'users#demote'
  get 'share', to: 'notes#getShare'
  post 'share', to: 'notes#share'
  get 'notesUser', to: 'notes#notesUser'

root "sessions#new"  
end