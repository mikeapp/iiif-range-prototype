# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :parent_object do
    resources :range
  end
  get '/range/:id', to: 'range#show', as: 'range_short'
end
