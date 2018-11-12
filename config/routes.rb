Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy] do
    collection do
      get :backdoor
      post :ready
    end
  end
  resource :home, only: [:show]

  root to: "home#show"

  resources :teams, :only => %i[index new create edit update destroy] do
    collection do
      get :select_join
      get :export
    end
    member do
      get :dashboard
      post :kick
      post :quit
      post :request_join
      post :cancel_join_request
      post :accept_join_request
      post :deny_join_request
      post :promote
    end
  end

  resources :users, :only => %i[edit update]

  resources :quests, :only => %i[index new create edit update destroy] do
    member do
      post :publish
      post :unpublish
    end
  end

  resource :teamquest, only: [:show] do
    member do
      get :step
      post :answer
    end
  end

  resources :steps
end
