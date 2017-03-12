Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root 'home#index'

  resources :words
  resources :categories
  resources :searches, exept: [:edit,:update] do
    get 'results/:word', to: 'results#index', as: :results
    get 'results/:word/:id', to: 'results#show', as: :result
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
