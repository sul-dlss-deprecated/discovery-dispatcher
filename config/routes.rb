Rails.application.routes.draw do
  match '/admin' => DelayedJobWeb, :anchor => false, via: [:get, :post]
end
