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

  resources :awssamplers, :only => %i[index] do
    collection do
      post :create_keypair
      get :delete_stack
      post :check_status
    end
    member do
      get :list_s3_buckets
    end
  end

  resources :teams, :only => %i[index new create edit update destroy] do
    collection do
      get :select_join
      get :export
      get :scoreboard
    end
    member do
      get :dashboard
      get :details
      post :kick
      post :quit
      post :request_join
      post :cancel_join_request
      post :accept_join_request
      post :deny_join_request
      post :promote
      post :ignore_joins
      post :watch_joins
    end
  end

  resources :users, :only => %i[edit update]

  resources :quests, :only => %i[index new create edit update destroy] do
    member do
      post :publish
      post :unpublish
      post :addprereq
      post :removeprereq
    end
  end

  resource :teamquest, only: [:show] do
    member do
      get :step
      post :answer
    end
  end

  resources :steps

  namespace :api do
    namespace :v1 do
      resources :api do
        collection do
          post :stack_complete
        end
      end
    end
  end
end
