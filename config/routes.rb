Rails.application.routes.draw do
  #resources :words
  #resources :categories
  root 'searches#index'
  resources :searches, exept: [:edit,:update] do
    get 'results/:word', to: 'results#index', as: :results
    get 'results/:word/:id', to: 'results#show', as: :result
    #resources :results, param: :word, only: [:index, :show]
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
