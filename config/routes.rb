Rails.application.routes.draw do

  
  devise_for :users
  resources :articles do
    collection do
      get 'search'
    end
  end
  resources :projects
  resources :contacts, only: [:new, :create]

  root 'static_pages#home'

  get '*path' => redirect('/')
end
