Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  resources :users, only: %i[create update]

  post '/sign_in', to: 'auth#sign_in'
  post '/avatar', to: 'users#avatar'
end
