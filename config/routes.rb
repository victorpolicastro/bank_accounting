Rails.application.routes.draw do
  resources :accounts, param: :id do
    resources :transactions
  end
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
