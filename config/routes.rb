Rails.application.routes.draw do
  resources :items, only: :new
  match '/admin' => DelayedJobWeb, :anchor => false, via: [:get, :post]
end
