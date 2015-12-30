Rails.application.routes.draw do
 
  devise_for :users
  resources :articles do
    collection do
      get 'search'
      get 'drafts'
    end
  end
  resources :projects
  resources :screencasts
  resources :contacts, only: [:new, :create]

  root 'static_pages#home'

  get '*path' => redirect('/')
end
