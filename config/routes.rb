Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "books#home"

  resources :books, only: [:index, :show]

  namespace :admin do
    root "dashboard#home"
    resources :users
    resources :sources
    resources :authors
    resources :categories
    resources :books
  end
end
