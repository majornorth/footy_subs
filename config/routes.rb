Pickup::Application.routes.draw do

  # get '/signup', to: 'signup#new'
  root :to => "signup#new"
  match '/signup/success', to: 'signup#success'

  resources :events, :users, :comments
  resources :sessions, only: [:new, :create, :destroy]
  resources :comments, only: [:create, :destroy]
  root :to => "events#index"

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/match/:id', to: 'events#show', via: :get
  match '/join', to: 'events#join'
  match '/leave', to: 'events#leave'
end
