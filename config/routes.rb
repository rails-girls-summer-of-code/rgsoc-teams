RgsocTeams::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  resources :users, except: [:new]

  resources :teams do
    resources :repositories
    resources :roles, only: [:new, :create, :destroy]
  end

  root to: 'activities#index'
end
