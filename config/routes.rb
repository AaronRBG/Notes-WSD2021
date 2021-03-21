Rails.application.routes.draw do
  #get "/notes", to: "notes#index"
 # root "notes#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 resource :notes
end
