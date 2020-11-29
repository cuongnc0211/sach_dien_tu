Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "books#home"

  resources :books, only: [:index, :show]
  namespace :download do
    resources :book_versions, only: :show
  end

  namespace :api do
    namespace :v1 do
      post :sign_up, to: "sessions#sign_up"
      post :sign_in, to: "sessions#sign_in"
    end
  end

  namespace :admin do
    root "dashboard#home"
    resources :users
    resources :sources
    resources :authors
    resources :categories
    resources :books
  end
end
