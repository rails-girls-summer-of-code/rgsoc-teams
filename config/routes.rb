RgsocTeams::Application.routes.draw do
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

  get 'users/info', to: 'users_info#index'
  resources :users, except: :new, concerns: [:has_roles, :impersonatable]
  resources :sources, only: :index
  resources :comments, only: :create
  resources :conferences
  resources :attendances
  resources :contributors, only: :index
  resources :students, only: :index
  resources :status_updates, only: :show
  resources :status_update_comments, only: :create
  resources :projects do
    get 'receipt', as: :receipt, on: :member
    post 'preview', on: :collection
  end

  get 'rating', to: 'rating/overview#index'
  namespace :rating do
    resources 'todos', controller: 'todos', only: [:index]
    namespace 'todos' do
      resources :ratings, only: [:create, :update]
      resources :comments, only: [:create]
      resources :applications, only: [:show, :edit, :update]
    end



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
    resources :sources
    resources :roles, only: [:new, :create, :destroy]
  end

  resources :roles, only: [] do
    put :confirm, on: :member
  end

  get 'calendar/index', as: :calendar
  get 'calendar/events', to: 'calendar#events'

  get 'pages/:page', to: 'pages#show', as: :page

  resources :mailings do
    resources :submissions
  end

  patch 'orga/seasons/switch_phase', to: 'orga/seasons#switch_phase', as: :switch_phase
  namespace :orga do
    root to: 'dashboard#index', as: :dashboard
    resources :projects, only: [:index] do
      member do
        put :accept
        put :pending
        put :reject
        put :lock
        put :unlock
      end
    end
    resources :teams
    resources :seasons
    resources :conferences
    resources :exports, only: [:index, :create]
  end

  namespace :students do
    resources :status_updates, :except => [:new] do
      post 'preview', on: :collection
    end
  end

  get 'supervisor', to: 'supervisor/dashboard#index'
  patch 'supervisor/notes', to: 'supervisor/notes#update'
  namespace :supervisor do
    get 'dashboard', to: 'dashboard#index'
    resources :comments, only: [:index, :create]
  end

  namespace :mentor do
    resources :applications, only: [:index, :show]
    resources :comments, only: [:create, :update]
  end

  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities
end
