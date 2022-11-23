Rails.application.routes.draw do
  devise_for :users

  root to: 'activities#index'

  resources :activities

  resources :categories do
    resources :products
  end
end
