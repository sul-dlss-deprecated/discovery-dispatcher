Rails.application.routes.draw do
  root 'about#index'
  get 'about/version' => 'about#version'
  get 'about' => 'about#version'

  resources :items, only: :new
  match '/admin' => DelayedJobWeb, :anchor => false, via: [:get, :post]
end
