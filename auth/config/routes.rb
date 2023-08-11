Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # devise_for :users, controllers: { sessions: 'sessions' }
  root "users#index"
  resources :users
  post '/jwt/validate', to: 'jwt#validate'
end
