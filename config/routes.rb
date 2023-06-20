# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users
      resources :rooms
      resources :reservations
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end
end
