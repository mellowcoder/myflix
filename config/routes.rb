Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: "queue_items#index"
  get 'people', to: "followed_relationships#index"
  
  resources :videos, only: [:index, :show] do
    get 'search', on: :collection
    resources :reviews, only: [:create]
  end
    
  resources :categories, only: [:show]
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:create]
  resources :followed_relationships, only: [:destroy]
  
  resources :queue_items, only: [:index, :create, :destroy] do
    put 'update_queue', on: :collection
  end
  
  get 'ui(/:action)', controller: 'ui'
end
