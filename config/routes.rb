RgsocTeams::Application.routes.draw do
  get 'status_updates/show'

  root to: 'activities#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  concern :has_roles do
    resources :roles, only: [:new, :create, :destroy, :update]
  end

  get 'users/info', to: 'users_info#index'
  resources :users, except: :new, concerns: :has_roles
  resources :sources, only: :index
  resources :comments, only: :create
  resources :conferences
  resources :attendances
  resources :contributors, only: :index
  resources :status_updates, only: :show
  resources :projects do
    member do
      get 'receipt', as: :receipt
    end
  end

  namespace :applications do
    get 'students/:id', to: 'students#show', as: 'student'
    get 'teams/:id', to: 'teams#show', as: 'team'
    get 'todos', to: 'todos#index', as: 'todos'
  end
  resources :applications, only: [:index, :show, :edit, :update]
  resources :ratings

  resources :application_drafts, except: [:show, :destroy] do
    member do
      put :apply
      get :check
    end
  end

  get 'application', to: 'applications#new'
  get 'application_forms', to: 'applications#new'
  post 'application_forms', to: 'applications#create'

  get 'apply', to: 'application_drafts#new', as: :apply

  get 'teams/info', to: 'teams_info#index'
  resources :teams, concerns: :has_roles do
    resources :join, only: [:new, :create]
    resources :sources
  end

  get 'calendar/index', as: :calendar
  get 'calendar/events', to: 'calendar#events'

  get 'pages/:page', to: 'pages#show', as: :page

  resources :mailings do
    resources :submissions
  end

  patch 'orga/seasons/switch_phase', to: 'orga/seasons#switch_phase', as: :switch_phase
  namespace :orga do
    resources :projects, only: [:index] do
      member do
        put :accept
        put :reject
        put :lock
        put :unlock
      end
    end
    resources :teams
    resources :seasons
  end

  namespace :students do
    resources :status_updates, :except => [:new]
  end

  get 'supervisor', to: 'supervisor/dashboard#index'
  patch 'supervisor/notes', to: 'supervisor/notes#update'
  namespace :supervisor do
    get 'dashboard', to: 'dashboard#index'
    resources :comments, only: [:index, :create]
  end

  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities
end
