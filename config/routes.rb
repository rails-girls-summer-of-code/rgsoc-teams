RgsocTeams::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } do
    delete 'sign_out' => 'devise/sessions#destroy'
  end

  resources :users

  resources :teams do
    resources :repositories
    resources :roles, only: [:new, :create, :destroy]
  end

  root to: 'activities#index'
end
