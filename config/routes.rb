Rails.application.routes.draw do
  get 'status_updates/show'

  root to: 'activities#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  concern :has_roles do
    resources :roles, only: [:new, :create, :destroy]
  end

  concern :impersonatable do
    unless Rails.env.production?
      post 'impersonate', on: :member
      post 'stop_impersonating', on: :collection
    end
  end

  resources :users, except: [:new, :index], concerns: [:has_roles, :impersonatable] do
    post 'resend_confirmation_instruction', on: :member
  end
  resources :comments, only: :create
  resources :conferences
  resources :conference_attendances, only: :update
  resources :contributors, only: :index
  resources :students, only: :index
  resources :status_updates, only: :show
  resources :status_update_comments, only: :create
  resources :projects do
    member do
      get :receipt, as: :receipt
      get :use_as_template
    end
    post 'preview', on: :collection
  end

  namespace :reviewers do
    root to: 'dashboard#index', as: :dashboard
    resources :todos, only: [:index]
    resources :applications, except: [:new, :create, :destroy]
    resources :ratings, only: [:create, :update]
    resources :comments, only: [:create]
  end

  resources :application_drafts, except: [:show, :destroy] do
    member do
      put :apply
      get :check
    end
  end

  get 'apply', to: 'application_drafts#new', as: :apply

  get 'teams/info', to: 'teams_info#index'
  resources :teams do
    resources :join, only: [:new, :create]
    resources :roles, only: [:new, :create, :destroy]
  end

  resources :roles, only: [] do
    put :confirm, on: :member
  end
  resources :mailings

  get 'calendar/index', as: :calendar
  get 'calendar/events', to: 'calendar#events'

  get 'pages/:page', to: 'pages#show', as: :page

  namespace :organizers do
    root to: 'dashboard#index', as: :dashboard
    patch 'seasons/switch_phase', to: 'seasons#switch_phase'
    get 'users/info', to: 'users_info#index', as: :users_info
    resources :projects, only: [:index] do
      member do
        put :accept
        put :start_review
        put :reject
        put :lock
        put :unlock
      end
    end
    resources :teams
    resources :seasons
    resources :conferences, except: :edit do
      collection { post :import }
    end
    resources :exports, only: [:index, :create]
    resources :mailings do
      resources :submissions
    end
  end

  namespace :students do
    resources :status_updates, except: [:new] do
      post 'preview', on: :collection
    end
  end

  namespace :supervisors do
    root to: 'dashboard#index', as: :dashboard
    resources :comments, only: [:index, :create]
    resource :notes, only: :update
  end

  namespace :mentors do
    resources :applications, only: [:index, :show] do
      member do
        put :fav
        put :signoff
      end
    end
    resources :comments, only: [:create, :update]
  end

  get '/community', to: 'community#index', as: :community
  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities
end
