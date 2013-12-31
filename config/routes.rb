Pickup::Application.routes.draw do

  # devise_for :users

  # get '/signup', to: 'signup#new'
  root :to => "signup#new"
  match '/signup/success', to: 'signup#success'

  resources :events, :users, :comments
  # resources :sessions, only: [:new, :create, :destroy]
  resources :comments, only: [:create, :destroy]
  # root :to => "events#index"

  devise_scope :user do
    get "/signin", :to => "devise/sessions#new"
  end
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/match/:id', to: 'events#show', via: :get
  match '/join', to: 'events#join'
  match '/leave', to: 'events#leave'
end
