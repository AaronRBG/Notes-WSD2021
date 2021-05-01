Rails.application.routes.draw do
  resources :user_notes
  resources :user_collections
  resources :users
  resources :sessions
  resources :notes
  resources :notecollections

  delete 'logout' => "sessions#logout"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'promote', to: 'users#promote'
  post 'demote', to: 'users#demote'
  get 'share', to: 'notes#getShare'
  post 'share', to: 'notes#share'
  get 'notesUser', to: 'notes#notesUser'
  get 'shareCollection', to: 'notecollections#getShare'
  post 'shareCollection', to: 'notecollections#share'
  get 'add', to: 'notecollections#getAdd'
  post 'add', to: 'notecollections#add'
  post 'removeNote', to: 'notecollections#removeNote'
  get 'notecollectionsUser', to: 'notecollections#notecollectionsUser'

root "sessions#new"  
end