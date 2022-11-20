Rails.application.routes.draw do
  devise_for :users
  root to: "activities#index"

  get '/activities', to: 'activities#index', as: :activities
  get '/activities/:id', to: 'activities#show', as: :activity
  get '/bookmarks', to: 'bookmarks#index', as: :bookmarks
  post '/activities/:activity_id/bookmarks', to: 'bookmarks#create', as: :activity_bookmarks
end
