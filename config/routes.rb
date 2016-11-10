Rails.application.routes.draw do
  root 'searches#index'
  resources :words
  resources :categories
  resources :searches, exept: [:edit,:update] do
    get 'results/:word', to: 'results#index', as: :results
    get 'results/:word/:id', to: 'results#show', as: :result
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
