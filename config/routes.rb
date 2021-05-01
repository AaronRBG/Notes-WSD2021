Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes
  resources :collection

  delete 'logout' => "sessions#logout"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'promote', to: 'users#promote'
  post 'demote', to: 'users#demote'
  get 'share', to: 'notes#getShare'
  post 'share', to: 'notes#share'
  get 'notesUser', to: 'notes#notesUser'
  get 'collectionUsers', to: 'collection#collectionUsers'

root "sessions#new"  
end