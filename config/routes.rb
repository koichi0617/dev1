Rails.application.routes.draw do
  root 'static_pages#home'
  get '/itiran', to: 'static_pages#itiran'
  get '/shousai', to: 'static_pages#shousai'
  get '/toukou', to: 'static_pages#toukou'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users

end
