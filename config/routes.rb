RgsocTeams::Application.routes.draw do
  root to: 'users#index'

  get 'application_forms', to: 'applications#new'
  post 'application_forms', to: 'applications#create'
  get 'application', to: 'applications#new'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  get 'users/info', to: 'users_info#index'
  resources :users, except: :new
  resources :sources, only: :index
  resources :comments, only: :create
  resources :conferences
  resources :attendances

  get 'teams/info', to: 'teams_info#index'
  resources :teams do
    resources :join, only: [:new, :create]
    resources :sources
    resources :roles, only: [:new, :create, :destroy]
  end

  get 'calendar/index', as: :calendar
  get 'calendar/events', to: 'calendar#events'

  get 'pages/:page', to: 'pages#show', as: :page

  resources :mailings do
    resources :submissions
  end

  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities
end
