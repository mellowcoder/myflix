Myflix::Application.routes.draw do
  root to: "pages#front"
  
  get 'home', to: 'videos#index'
  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    resources :reviews, only: [:create]
  end
    
  resources :categories, only: [:show]
  
  
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new', as: 'register_with_invite_token'
  resources :users, only: [:create, :show]
  
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  resources :sessions, only: [:create]
  
  get 'people', to: "followed_relationships#index"
  resources :followed_relationships, only: [:create, :destroy]
  
  get 'my_queue', to: "queue_items#index"
  resources :queue_items, only: [:index, :create, :destroy] do
    put 'update_queue', on: :collection
  end
  
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirmation'
  get 'invalid_token', to: 'forgot_passwords#invalid_token'
  resources :forgot_passwords, only: [:create, :edit, :update]
  
  get 'invite_confirmed', to: 'invites#confirmation'
  resources :invites, only: [:new, :create]
  
  get 'ui(/:action)', controller: 'ui'
end
