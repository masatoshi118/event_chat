Rails.application.routes.draw do
  get 'rooms/show'
  root to: 'events#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  resources :users, only: [:show, :edit, :update]
  patch '/users/:id/user_update', to: 'users#user_update'
  resources :events do
    resource :joins, only: [:create, :destroy]
  end
  get 'search', to: 'events#search'
  get '/events/:id/chat_room', to: 'rooms#show'
  resources :messages, only: [:create, :destroy]
  mount ActionCable.server => '/cable'
end
