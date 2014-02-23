RgsocTeams::Application.routes.draw do

  get 'application_forms', to: 'applications#new'
  post 'application_forms', to: 'applications#create'
  get 'application', to: 'applications#new'

  get "calendar/index"
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

  get 'calendar/:action', controller: 'calendar'

  get 'pages/:page', to: 'pages#show', as: :page

  resources :mailings do
    resources :submissions
  end

  root to: 'activities#index'
  # get 'activities(.:format)', to: 'activities#index', as: :activities
  get 'activities(/page/:page)(.:format)', to: 'activities#index', as: :activities


  # match 'application_form' => 'application_form#new', :as => 'application_form', :via => :get
  # match 'application_form' => 'application_form#create', :as => 'application_form', :via => :post
end
