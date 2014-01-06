Pickup::Application.routes.draw do

  devise_for :users, :path => "", :path_names => { :sign_in => "signin", :sign_up => "signup"}

  # get '/signup', to: 'signup#new'

  match '/signup/success', to: 'signup#success'

  resources :events, :users, :comments
  # resources :sessions, only: [:new, :create, :destroy]
  resources :comments, only: [:create, :destroy]
  # root :to => "events#index"

  devise_scope :user do
    get "/signin", :to => "devise/sessions#new"
    get "/signup", :to => "devise/registrations#new"
  end

  match '/signout', to: 'sessions#destroy', via: :delete
  match '/match/:id', to: 'events#show', via: :get, as: "match"
  match '/match/:id/edit', to: 'events#edit', via: :get, as: "edit_match"
  match 'player/:id/edit', to: 'users#edit', via: :get, as: "edit_user"
  match 'matches', to: 'events#index'
  match '/join', to: 'events#join'
  match '/leave', to: 'events#leave'
  root :to => "signup#new"
end
