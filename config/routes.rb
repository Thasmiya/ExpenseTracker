Rails.application.routes.draw do
  post '/signup', to: 'users#create'
  post '/login', to: 'auth#login'

  resources :categories
  resources :expenses
  resources :budgets

  namespace :reports do
    get 'monthly', to: 'reports#monthly'
    get 'weekly', to: 'reports#weekly'
    get 'budget_status', to: 'reports#budget_status'
  end

  # Or simple endpoints without namespace:
  get '/reports/monthly', to: 'reports#monthly'
  get '/reports/weekly', to: 'reports#weekly'
  get '/reports/budget_status', to: 'reports#budget_status'
end
