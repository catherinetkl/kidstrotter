Rails.application.routes.draw do
  devise_for :users

  root to: 'activities#homepage'

  resources :categories do
    resources :activities
  end

  resources :activities do
    resources :bookings, only: %i[create new]
    resources :bookmarks, only: %i[create new]
  end

  resources :bookings do
    resources :reviews, only: %i[create new]
  end

  resources :bookings, only: %i[index show destroy]
  resources :bookmarks, only: %i[index show destroy]
  resources :reviews, only: %i[index destroy]
  resources :activities
end
