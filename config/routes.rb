Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  authenticated :user do
    root to: 'searches#index', as: :authenticated_root
  end
  root 'home#index'

  devise_scope :user do
   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :words
  resources :categories
  resources :searches, exept: [:edit,:update] do
    get 'results/:word', to: 'results#index', as: :results
    get 'results/:word/:id', to: 'results#show', as: :result
  end

  get 'about_us', to: 'about_us#index', as: :about_us

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
