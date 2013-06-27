RgsocTeams::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  resources :users, except: :new
  resources :sources, only: :index

  resources :teams do
    resources :join, only: [:new, :create]
    resources :sources
    resources :roles, only: [:new, :create, :destroy]
  end

  get 'pages/:page', to: 'pages#show', as: :page

  root to: 'activities#index'
  get 'activities(.:format)', to: 'activities#index', as: :activities
end
