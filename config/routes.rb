Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  #post '/microposts/:id', to: 'comments#create'
  post '/microposts/:id/solve', to: 'microposts#solve',   as: 'solve'
  delete '/microposts/:id', to: 'comments#destroy'

  resources :users
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:index, :new, :create, :show, :solve, :destroy] do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end
  resources :boards, only: [:index, :new, :create, :show, :destroy]
  resources :rooms, only: [:index, :create, :show]
  resources :messages, only: [:create, :edit, :update, :destroy]
  

end
