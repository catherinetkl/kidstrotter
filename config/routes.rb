Rails.application.routes.draw do
  devise_for :users
  # Category index is the homepage, not activity index.
  root to: 'categories#index'

  resources :activities
  resources :categories
end
