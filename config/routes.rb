Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]

  root to: "home#show"

  resources :teams, :only => %i[index new create edit update destroy] do
    collection do
      get :select_join
      get :export
    end
    member do
      post :join
      get :dashboard
      post :kick
    end
  end
end
