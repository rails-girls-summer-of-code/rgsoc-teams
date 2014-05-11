RgsocTeams::Application.routes.draw do
  root to: 'users#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  concern :has_roles do
    resources :roles, only: [:new, :create, :destroy]
  end

  get 'users/info', to: 'users_info#index'
  resources :users, except: :new, concerns: :has_roles
  resources :sources, only: :index
  resources :comments, only: :create
  resources :conferences
  resources :attendances

  resources :applications do
    resources :ratings
  end
  get 'application', to: 'applications#new', as: :apply
  get 'application_forms', to: 'applications#new'
  post 'application_forms', to: 'applications#create'

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

  resources :companies

  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities
end
