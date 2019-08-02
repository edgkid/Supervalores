Rails.application.routes.draw do
  root to: 'pages#index'
  devise_for :users
  resources :users
  resources :t_leyendas
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'users#index'
end
