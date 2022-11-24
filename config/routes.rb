Rails.application.routes.draw do
  devise_for :users

  root to: 'activities#landing'

  resources :categories do
    resources :activities
  end

  resources :activities do
    resources :bookings, only: %i[create new]
  end

  resources :bookmarks do
    resources :reviews, only: %i[create new]
  end

  resources :bookings, only: %i[index show destroy]
  resources :activities
end
