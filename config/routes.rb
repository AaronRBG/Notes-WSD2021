Rails.application.routes.draw do
  resources :user_notes
  resources :users
  resources :sessions
  resources :notes

  delete 'logout' => "sessions#logout"
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'promote', to: 'users#promote'
  post 'demote', to: 'users#demote'
  get 'share', to: 'notes#getShare'
  post 'share', to: 'notes#share'
  get 'notesUser', to: 'notes#notesUser'
  get 'shareCollection', to: 'collections#getShare'
  post 'shareCollection', to: 'collections#share'
  get 'add', to: 'collections#getAdd'
  post 'add', to: 'collections#add'
  post 'removeNote', to: 'collections#removeNote'
  get 'collectionsUser', to: 'collections#collectionsUser'

root "sessions#new"  
end